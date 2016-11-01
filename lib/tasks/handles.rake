namespace :handles do
  desc "Modify handles that currently exist in IMS and imports them to Purple"
  task import: :environment do
    # Log to STDOUT
    Rails.logger = Logger.new(STDOUT)
    STDOUT.puts "Please enter the full path to a CSV with Column 0: GenericWork ID and it's Column 1: Handle:"
    handle_csv = STDIN.gets.strip
    STDOUT.puts "Does this CSV have headers? (y / n):"
    headers = STDIN.gets.strip == "y" || STDIN.gets.strip == "Y" ? true : false
    # Todo --> put this HandleService
    handle_service = HandleService.new(nil)
    CSV.foreach(handle_csv, headers: headers).each do |row|
      generic_work_pid = row[0]
      handle = row[1]
      handle_service.modify_handle(generic_work_pid, handle)
    end
  end
end
