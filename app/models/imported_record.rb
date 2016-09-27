class ImportedRecord < ActiveRecord::Base
  include FedoraObjectAssociations

  belongs_to :import

  belongs_to :file, foreign_key: 'generic_work_pid', class_name: 'GenericWork'

  def completely_destroy_file!
    if file.present?
      file.destroy
      file.eradicate
    end
  end

end
