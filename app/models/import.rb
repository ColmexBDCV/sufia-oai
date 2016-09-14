class Import < ActiveRecord::Base
  include FedoraObjectAssociations

  belongs_to :user
  has_many :import_field_mappings, dependent: :destroy
  has_many :imported_records, dependent: :destroy
  belongs_to :unit
  accepts_nested_attributes_for :import_field_mappings

  # belongs_to_fedora :unit, class_name: 'Hydra::Admin::Collection'
  # belongs_to_fedora :batch

  has_attached_file :csv, path: "#{ENV['IMPORT_PATH']}/csv/:id/:basename.:extension"

  validates_attachment :csv, content_type: { content_type: ['text/csv', 'application/vnd.ms-excel', 'application/octet-stream'] }
  validates_attachment_presence :csv
  validates :name, :unit_id, :rights, :preservation_level, :import_type, :server_import_location_name, presence: true
  validate :validate_unit
  validate :validate_csv_contents

  # before_create :create_batch_object

  enum status: { not_ready: 0, ready: 1, in_progress: 2, complete: 3, reverting: 4, final: 5 }

  REQUIRED_FIELDS = %w(title image_filename).freeze

  scope :editable, -> { where(status: [ Import.statuses[:ready], Import.statuses[:not_ready] ]) }
  scope :reportable, -> { where(status: [ Import.statuses[:complete], Import.statuses[:in_progress], Import.statuses[:final] ]) }
  scope :with_imported_file, -> (generic_work) { joins(:imported_records).where(imported_records: { generic_work_pid: generic_work.id } ) }

  def editable?
    ready? || not_ready?
  end

  def reportable?
    complete? || in_progress? || final?
  end

  def undoable?
    complete?
  end

  def status_name
    status.titleize
  end

  # Validate import field mapping making sure required fields have mapping
  def validate_import_mappings
    import_field_mappings.each do |field|
      if REQUIRED_FIELDS.include?(field.key) && field.value.all?(&:blank?)
        not_ready!
        return false
      end
    end
    ready!
    true
  end

  def invalid_records
    invalid_records = []
    successfully_imported_records.each do |imported_record|
      invalid_fields = []
      params = {
        q: "id:#{imported_record.generic_work_pid}",
        fq: "has_model_ssim:GenericFile",
        qt: "standard",
        wt: "json",
        indent: "true"
      }
      query_url = "#{ActiveFedora::SolrService.instance.conn.options[:url]}/select?#{params.to_query}"
      generic_work_response = HTTParty.get(query_url)

      REQUIRED_FIELDS.each do |field|
        next if field == 'image_filename'
        formated_field = field.to_s + "_tesim"
        field_value = generic_work_response["response"]["docs"].first[formated_field] if generic_work_response["response"].present? && generic_work_response["response"]["docs"].present?
        invalid_fields << field if field_value.blank?
      end

      next if invalid_fields.blank?
      name = if generic_work_response["response"].present? && generic_work_response["response"]["docs"].present?
               generic_work_response["response"]["docs"].first["title_tesim"].blank? ? generic_work_response["response"]["docs"].first["id"] : "#{generic_work_response['response']['docs'].first['id']} - #{generic_work_response['response']['docs'].first['title_tesim']} "
             else
               "invalid"
             end
      invalid_records << { generic_work: generic_work_response, name: name,
                           fields: invalid_fields, generic_work_pid: imported_record.generic_work_pid.to_s }
    end
    invalid_records
  end

  # Get all the records that were not succesfully ingested during import
  def successfully_imported_records
    imported_records.where(success: true)
  end

  # Get all the records that were not succesfully ingested during import
  def unimported_records
    imported_records.where(success: false)
  end

  def number_of_records_with_errors
    invalid_records.count + unimported_records.count
  end

  def number_of_successful_records
    imported_records.count - number_of_records_with_errors
  end

  def all_records_imported?
    imported_records.size >= csv_file_row_count
  end

  def percent_records_imported
    csv_file_row_count.zero? ? 0 : imported_records.count.to_f / csv_file_row_count.to_f * 100
  end

  def last_run_at
    imported_records.order(created_at: :desc).first.try(:created_at)
  end

  # Preview import process from csv
  def preview_import_from_csv(num_of_previews, offset = 0)
    preview_objects = {}
    CSV.foreach(csv_file_path, csv_options).each_with_index do |row, i|
      if i >= offset && i < (num_of_previews + offset)
        preview_objects[i] = preview_row(row)
      end
    end

    preview_objects
  end

  def image_path_from_csv_row(row_num)
    preview = {}

    CSV.foreach(csv_file_path, csv_options).each_with_index do |row, i|
      preview = preview_row(row) if i == row_num
    end

    image_path_for preview[:image_filename]
  end

  def directory_file_count
    Dir[File.join(image_base, '**', '*')].count { |f| File.file?(f) }
  end

  def csv_file_row_count
    # get import Csv file
    CSV.foreach(csv_file_path, csv_options).count
  rescue
    0
  end

  def resumable?
    in_progress? && csv_file_row_count > imported_records.size
  end

  def preview_row(row)
    preview_object = {}
    field_mappings = import_field_mappings.to_a
    field_mappings.each do |field_mapping|
      key_column_number_arr = import_field_mappings.find_by_key(field_mapping.key).value.reject!(&:blank?)
      key_column_value_arr = []

      unless key_column_number_arr.blank?
        key_column_number_arr.each do |num|
          key_column_value_arr << row[num.to_i]
        end
      end

      preview_object[field_mapping.key.to_sym] = key_column_value_arr
    end
    preview_object
  end

  # Defines path where imported csv files are stored
  def csv_import_path
    File.join(ENV['IMPORT_PATH'], 'csv', id.to_s)
  end

  def csv_file_path
    File.join(csv_import_path, csv_file_name)
  end

  def image_base
    File.join(ENV['FEDORA_NFS_UPLOAD_PATH'], server_import_location_name)
  end

  def image_path_for(filename)
    File.join(image_base, filename)
  end

  def csv_columns
    csv = CSV.read csv_file_path, headers: true
    csv.headers.map.with_index { |item, index| ["Column: #{index + 1} - #{item}", index] }
  end

  def unit_name
    unit.try(:name)
  end

  private

  def validate_unit
    errors.add :unit_id, "is invalid" unless valid_unit?
  end

  def valid_unit?
    unit_id.present?
  end

  def validate_csv_contents
    CSV.foreach(Paperclip.io_adapters.for(csv).path, csv_options).each_with_index do |row, i|
    end
  rescue
    errors.add :csv, 'contents appear invalid'
  end

  def csv_options
    { headers: includes_headers? ? true : false, encoding: "UTF-8" }
  end

  def create_batch_object
    self.batch = Batch.create
  end
end
