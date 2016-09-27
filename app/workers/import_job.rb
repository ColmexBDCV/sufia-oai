class ImportJob < ActiveJob::Base
  queue_as :ingest

  def perform(import_id, user_id, start_at = nil)
    import = Import.find(import_id)
    user = User.find(user_id)
    BatchImportService.new(import, user).process(start_at)
  end
end
