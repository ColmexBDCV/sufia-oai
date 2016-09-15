class MintHandleJob < ActiveJob::Base
  queue_as :ingest

  def perform(file_id)
    file = GenericFile.find file_id
    HandleService.new(file).mint
  end
end
