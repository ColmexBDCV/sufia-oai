class DestroyImportedRecordJob < ActiveJob::Base
  queue_as :ingest

  def perform(record_id, user_id)
    record = ImportedRecord.includes(:import).find(record_id)
    user = User.find user_id
    BatchImportService.new(record.import, user).destroy_record(record)
  end
end
