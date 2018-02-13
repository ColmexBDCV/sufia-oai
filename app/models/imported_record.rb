class ImportedRecord < ActiveRecord::Base
  include FedoraObjectAssociations

  belongs_to :import

  belongs_to :file, foreign_key: 'generic_work_pid', class_name: 'GenericWork'

  def completely_destroy_file!
    begin
      # will throw error if there is generic file with this id does not exist
      file.present?
    rescue
      return false
    end
    return false unless file.present?
    file.destroy
    file.eradicate
  end
end
