class IngestLocalImportFileJob < ActiveJob::Base
  queue_as :ingest

  def perform(generic_work_id, path, user_key)
    user = User.find_by_user_key(user_key)
    raise "Unable to find user for #{user_key}" unless user

    filename = File.basename(path)
    generic_work = GenericWork.find(generic_work_id)
    actor = CurationConcerns::CurationConcern.actor(generic_work, user)

    if actor.create_content(File.open(path), filename, 'content', mime_type(filename))
      ContentDepositEventJob.perform_later(generic_work.id, user_key)
      Rails.logger.info "Local file ingest: The file (#{filename}) was successfully deposited"
    else
      Rails.logger.error "Local file ingest error: There was a problem depositing (#{filename})"
    end
  end

  def job_user
    User.batchuser
  end

  def mime_type(file_name)
    mime_types = MIME::Types.of(file_name)
    mime_types.empty? ? "application/octet-stream" : mime_types.first.content_type
  end
end
