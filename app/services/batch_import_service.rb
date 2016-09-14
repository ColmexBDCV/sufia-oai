class BatchImportService
  def initialize(import, user)
    @import = import
    @user = user
  end

  def schedule
    return false unless @import.ready?
    ImportJob.perform_now(@import.id, @user.id)
    @import.in_progress!
  end

  def process(start_at = nil)
    options = { headers: @import.includes_headers? ? true : false }

    CSV.foreach(@import.csv_file_path, options ).each_with_index do |row, i|
      current_row = @import.includes_headers? ? i + 2 : i + 1
      next unless start_at.nil? || current_row > start_at

      csv_style_array = []
      row.each { |arr| csv_style_array << arr }
      csv_row_array = []
      csv_style_array.each { |arr| csv_row_array << arr.last }
      ProcessImportItem.perform_now(@import.id, csv_row_array, @user.id, current_row)
    end
  end

  def import_item(row, current_row)
    begin
      generic_work = ingest(row)
      record = ImportedRecord.find_or_create_by(import_id: @import.id, csv_row: current_row, generic_work_pid: generic_work.id)
      record.update(success: true)

    rescue => e
      Rails.logger.error "------import ingest saving error------"
      Rails.logger.error
      record = ImportedRecord.find_or_create_by(import_id: @import.id, csv_row: current_row)
      record.update(success: false, message: e.message)
    end

    # import has finished - set import status to complete
    @import.complete! if @import.all_records_imported?
  end

  def resume
    return false unless @import.is_resumable?
    ImportJob.perform_now(@import.id, @user.id, @import.imported_records.last.try(:csv_row))
    @import.in_progress!
  end

  def undo
    @import.reverting!
    UndoImportJob.perform_now(@import.id, @user.id)
  end

  def revert_records
    @import.imported_records.each do |record|
      DestroyImportedRecordJob.perform_now(record.id, @user.id)
    end
  end

  def destroy_record(record)
    record.completely_destroy_file!
    record.destroy
    @import.ready! if @import.reload.imported_records.size.zero?
  end

  def finalize
    return false unless @import.complete?
    @import.final!
    ScheduleMintingJob.perform_now(@import.id, @user.id)
  end

  def mint
    @import.imported_records.each do |record|
      MintHandleJob.perform_now(record.file.id) if record.file.present?
    end
  end

  private

  def ingest(row)
    filename = get_filename_from(row)
    basename = File.basename(filename)
    image_path = @import.image_path_for filename
    raise "File #{filename} was not found." unless File.file? image_path

    # Ingest files already on disk
    gw = GenericWork.new(label: basename)
    # gw.relative_path = filename if filename != basename
    # actor = CurationConcerns::CurationConcern.actor(gw, @user)
    # actor.create_metadata @import.batch_id
    # gw.collection_id = @import.admin_collection_id
    depositor = @user.email

    assign_csv_values_to_genericwork(row, gw)
    gw.rights = [@import.rights]
    gw.preservation_level_rationale = @import.preservation_level
    gw.preservation_level = "Full"
    gw.visibility = @import.visibility
    gw.unit = @import.unit.key
    gw.depositor = depositor
    gw.apply_depositor_metadata(depositor)
    gw.save!

    fs = FileSet.new
      fs.title << gw.title
    fs.depositor = depositor
    fs.apply_depositor_metadata(depositor)
      fs.save!

    gw.ordered_members << fs
    gw.save!

    # IngestLocalImportFileJob.perform_now(gw.id, image_path, @user.user_key)
    IngestFileJob.perform_now(fs, image_path, "application/octet-stream", User.find_by(email: depositor))
  end

  def get_filename_from(row)
    filename_column_number = @import.import_field_mappings.where(key: 'image_filename').first.value
    filename = row[filename_column_number.last.to_i]
    raise 'filename cannot be blank' if filename.blank?
    filename
  end

  # Maps a specific row of csv data to a generic_work object for ingest
  def assign_csv_values_to_genericwork(row, generic_work)
    field_mappings = @import.import_field_mappings.where('import_field_mappings.key != ?', 'image_filename')
    field_mappings.each do |field_mapping|
      key_column_number_arr = @import.import_field_mappings.where(key: field_mapping.key).first.value.reject!( &:blank? )
      key_column_value_arr = []

      # For certain fields the values in the csv are comma delimeted and need to be parsed
      if field_mapping.key == 'subject'
        key_column_number_arr.each do |num|
          key_column_value_arr += (row[num.to_i].try(:split, ',') || [])
        end
      elsif field_mapping.key == 'collection_identifier'
        # it's not a multivalue field so let's just get the first mapping
        key_column_number_arr.each do |num|
          generic_work.collection_identifier = row[num.to_i]
          break
        end

      elsif field_mapping.key == 'measurements'
        key_column_number_arr.each do |num|
          measurement_hash = measurement_format_for(row[num.to_i].try(:strip))
          next if measurement_hash.nil?
          # insert field as a measurement object
          measurement = Osul::VRA::Measurement.create(measurement: measurement_hash[:width], measurement_unit: measurement_hash[:unit], measurement_type: "width")

          generic_work.measurements << measurement
          measurement = Osul::VRA::Measurement.create(measurement: measurement_hash[:height], measurement_unit: measurement_hash[:unit], measurement_type: "height")
          generic_work.measurements << measurement
        end

      elsif field_mapping.key == 'materials'
        key_column_number_arr.each do |num|
          material_hash = material_format_for(row[num.to_i].try(:strip))
          unless material_hash.nil?
            material = Osul::VRA::Material.create(material_hash)
            generic_work.materials << material
          end
        end

      else
        key_column_number_arr.each do |num|
          key_column_value_arr << row[num.to_i]
        end
      end

      # materials and measurements are associations so they are updated differently
      unless field_mapping.key == 'materials' || field_mapping.key == 'measurements' || field_mapping.key == 'collection_identifier'
        key_column_value_arr = key_column_value_arr.map.reject( &:blank? )
        generic_work.send("#{field_mapping.key}=".to_sym, key_column_value_arr)
      end
    end
  end

  def measurement_format_for(field_value)
    # format (34.5 x 54.34 cm)
    match_result = /\A(\d*\.?\d+)[[:space:]]x[[:space:]](\d*\.?\d+)[[:space:]](mm|cm|m|in|ft)\Z/.match(field_value)
    unless match_result.nil?
      result = { height: match_result[1], width: match_result[2], unit: match_result[3] }
    end
    result
  end

  def material_format_for(value)
    # format paper (parchment)
    # material (type-optional)
    match_result = /\A([^\s]+)\s*(?:\((.+)\))?\Z/.match(value)
    unless match_result.nil?
      result = { material: match_result[1] }
      result[:material_type] = match_result[2] unless match_result[2].nil?
    end
    result
  end
end
