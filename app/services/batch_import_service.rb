class BatchImportService
  def initialize(import, user)
    @import = import
    @user = user
  end

  def schedule
    return false unless @import.ready?
    ImportJob.perform_later(@import.id, @user.id)
    @import.in_progress!
  end

  # process -- determines if the CSV is a complex CSV or just a simple one.
  # If the CSV is complex, it grabes the Metadata, along with an array of files (fileset) for that metadata.
  # If the CSV is simple, it will just grab the one image and the metadata per CSV record.
  def process(start_at = nil)
    options = { headers: @import.includes_headers? ? true : false }
    row_count = File.read(@import.csv_file_path).split(/\r/).count

    CSV.foreach(@import.csv_file_path, options ).each_with_index do |row, ind|
      current_row = @import.includes_headers? ? ind + 2 : ind + 1
      next unless start_at.nil? || current_row > start_at

      csv_processor = CSVProcessor.new(get_pid_from(row), @import.get_column_from(row, 'image_filename'))
      if csv_processor.complex_object?
        CSV.foreach(@import.csv_file_path, options).each_with_index do |child, j|
          next unless j >= (ind + 1)

          # The outer loop needs to know where the inner loop ended up.
          start_at = j + 1
          # If this inner loop hits the end, we need to add 1 to start_at so
          # that the outer loop actually ends.
          if start_at == row_count - 1
            start_at += 1
          end

          # Retrieve this records' cid (child id) which points to the parent that
          # this record will be associated with.
          # If this is a child to the current parent, just retrieve the filename and
          # add it to the fileset array.
          # If the cid != pid, then we should break out of the loop.
          # TODO: We'll need to figure out if we shouldn't loop through the entire array. There might
          # be times when a child is added at the bottom of the CSV and we'll end up missing it if
          # we keep the logic as it.
          csv_processor.build_csv_array(row) # Build CSV once.
          if csv_processor.child?(get_cid_from(child))
            csv_processor.add_file(get_filename_from(child), get_title_from(child))
          else
            # Simply break out so we know how far we've gone in the CSV file.
            break
          end
        end
      else
        # Once we're done collection the files, create the csv_row_array for the GenericWork record
        csv_processor.add_file(get_filename_from(row), get_title_from(row))
        csv_processor.build_csv_array(row)
      end
      csv_processor.debug
      process_import_item(current_row, csv_processor)
    end
  end

  def import_item(row, current_row, files=[])
    begin
      generic_work = ingest(row, files)
      record = ImportedRecord.find_or_create_by(import_id: @import.id, csv_row: current_row, generic_work_pid: generic_work.id)
      record.update(success: true)

    rescue => e
      Rails.logger.error "------import ingest saving error------"
      Rails.logger.error e.message
      Rails.logger.error
      record = ImportedRecord.find_or_create_by(import_id: @import.id, csv_row: current_row)
      record.update(success: false, message: e.message)
    end

    # import has finished - set import status to complete
    @import.complete! if @import.all_records_imported?
  end

  def resume
    return false unless @import.resumable?
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

  def ingest(row, files = [])
    # Ingest files already on disk
    gw = GenericWork.new
    depositor = @user.email
    assign_csv_values_to_genericwork(row, gw)
    gw.rights = [@import.rights]
    gw.preservation_level_rationale = @import.preservation_level
    gw.preservation_level = "Full"
    gw.visibility = @import.visibility
    gw.unit = @import.unit.key if @import.unit
    gw.depositor = depositor
    gw.apply_depositor_metadata(depositor)
    gw.save

    files.each do |file|
      filename = file[:filename]
      basename = File.basename(filename)
      image_path = @import.image_path_for(filename)
      raise "File #{filename} was not found." unless File.file? image_path

      fs = create_fileset(file[:title], image_path, depositor)
      fs_actor = CurationConcerns::Actors::FileSetActor.new(fs, User.find_by(email: depositor))
      fs_actor.create_metadata(gw, {})
      gw.date_uploaded = CurationConcerns::TimeService.time_in_utc

      gw.save!
    end

    add_generic_work_to_collection(gw, @import.collection_id) if @import.collection_id.present?

    gw
  end

  def add_generic_work_to_collection(gw, collection_id)
    collection = Collection.find(collection_id)
    collection.members << gw
    collection.save!
  end

  def create_fileset(title, image_path, depositor)
    fs = FileSet.new
    fs.title << title
    fs.depositor = depositor
    fs.apply_depositor_metadata(depositor)
    fs.save!
    IngestFileJob.perform_now(fs, image_path, "application/octet-stream", User.find_by(email: depositor))
    CreateDerivativesJob.perform_now(fs, fs.original_file.id)
    fs
  end

  def process_import_item(current_row, csv_processor)
    ProcessImportItem.perform_now(@import.id, csv_processor.csv_row_array, @user.id, current_row, csv_processor.files)
  end

  def get_filename_from(row)
    filename = @import.get_column_from(row, 'image_filename')
    raise 'filename cannot be blank' if filename.blank?
    filename
  end

  def get_pid_from(row)
    @import.get_column_from(row, 'pid')
  end

  def get_cid_from(row)
    @import.get_column_from(row, 'cid')
  end

  def get_title_from(row)
    @import.get_column_from(row, 'title')
  end

  def subjects(row, key_column_number_arr, key_column_value_arr)
    key_column_number_arr.each do |num|
      key_column_value_arr += (row[num.to_i].try(:split, ',') || [])
    end
    key_column_value_arr
  end

  def collection_identifiers(row, key_column_number_arr, generic_work)
    key_column_number_arr.each do |num|
      generic_work.collection_identifier = row[num.to_i]
      break
    end
  end

  def measurements(row, key_column_number_arr, generic_work)
    key_column_number_arr.each do |num|
      measurement_hash = measurement_format_for(row[num.to_i].try(:strip))
      next if measurement_hash.nil?
      # insert field as a measurement object
      measurement = Osul::VRA::Measurement.create(measurement: measurement_hash[:width], measurement_unit: measurement_hash[:unit], measurement_type: "width")
      generic_work.measurements << measurement
      measurement = Osul::VRA::Measurement.create(measurement: measurement_hash[:height], measurement_unit: measurement_hash[:unit], measurement_type: "height")
      generic_work.measurements << measurement
    end
  end

  def materials(row, key_column_number_arr, generic_work)
    key_column_number_arr.each do |num|
      material_hash = material_format_for(row[num.to_i].try(:strip))
      unless material_hash.nil?
        material = Osul::VRA::Material.create(material_hash)
        generic_work.materials << material
      end
    end
  end

  def other_metadata(row, key_column_number_arr, key_column_value_arr)
    key_column_number_arr.each do |num|
      key_column_value_arr << row[num.to_i]
    end
    key_column_value_arr
  end

  def process_field_mappings(row, field_mappings, generic_work)
    field_mappings.each do |field_mapping|
      next if field_mapping.key.in?(["pid", "cid"])
      key_column_number_arr = @import.import_field_mappings.where(key: field_mapping.key).first.value.reject!( &:blank? )
      key_column_value_arr = []

      # For certain fields the values in the csv are comma delimeted and need to be parsed
      if field_mapping.key == 'subject'
        key_column_value_arr = subjects(row, key_column_number_arr, key_column_value_arr)
      elsif field_mapping.key == 'collection_identifier'
        collection_identifiers(row, key_column_number_arr, generic_work)
        next
      elsif field_mapping.key == 'measurements'
        measurements(row, key_column_number_arr, generic_work)
        next
      elsif field_mapping.key == 'materials'
        materials(row, key_column_number_arr, generic_work)
        next
      else
        key_column_value_arr = other_metadata(row, key_column_number_arr, key_column_value_arr)
      end

      key_column_value_arr = key_column_value_arr.map.reject( &:blank? )
      generic_work.send("#{field_mapping.key}=".to_sym, key_column_value_arr)
    end
  end

  # Maps a specific row of csv data to a generic_work object for ingest
  def assign_csv_values_to_genericwork(row, generic_work)
    field_mappings = @import.import_field_mappings.where('import_field_mappings.key != ?', 'image_filename')
    process_field_mappings(row, field_mappings, generic_work)
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
