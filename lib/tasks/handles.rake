namespace :handles do
  desc "Modify handles that currently exist in IMS and imports them to Purple"
  task import_handles: :environment do
    generic_works = GenericWork.where(:handle)
    generic_works.each do |generic_work|
      handle_service = HandleService.new(generic_work)
      handle_service.modify_handle!
    end
  end
end
