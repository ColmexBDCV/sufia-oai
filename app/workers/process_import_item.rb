class ProcessImportItem < ActiveJob::Base
  queue_as :ingest

  def perform(import_id, row, current_user_id, current_row, files)
    import = Import.find(import_id)
    current_user = User.find(current_user_id)
    BatchImportService.new(import, current_user).import_item(row, current_row, files)
  end
end
