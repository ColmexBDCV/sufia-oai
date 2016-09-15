require "./lib/import/import.rb"

namespace :import do
  desc "Undo last import"
  task undo_last_import: :environment do
    STDOUT.puts "Are you sure you want to undo last import? (y/n):"
    input = STDIN.gets.strip
    if input == 'y'
      puts "Start time is:" + Time.zone.now.to_s
      puts "Undoing last import..."
      importer = MyImport::ImportSettings.new(nil, nil, nil, nil)
      service = MyImport::ImportService.new(importer)
      service.undo_imported_items
      puts "everything has been cleared"
    else
      STDOUT.puts "Bye!"
    end
  end

  desc "Get all generic_file items and store locally"
  task get_all_items: :environment do
    STDOUT.puts "Please enter the sufia6 root url where the items are store (without trailing slash):"
    sufia6_root_url = STDIN.gets.strip
    puts "starting to get and store all items locally..."
    start_time = Time.zone.now
    importer = MyImport::ImportSettings.new(nil, nil, nil, sufia6_root_url)
    service = MyImport::ImportService.new(importer)
    service.request_all_items
    puts "get_all_items task duration: " + Time.at(Time.now - start_time).utc.strftime("%H:%M:%S")
    puts "done storing all items"
  end

  desc "Import all items"
  task import_all: :environment do
    STDOUT.puts "Please enter the old fedora root url (without trailing slash):"
    old_fedora_root_url = STDIN.gets.strip
    puts "starting importing all items..."
    start_time = Time.zone.now
    importer = MyImport::ImportSettings.new(nil, nil, old_fedora_root_url, nil)
    service = MyImport::ImportService.new(importer)
    service.import
    puts "import_all task duration: " + Time.at(Time.now - start_time).utc.strftime("%H:%M:%S")
    puts "done importing all items"
  end

  desc "Migrate everything"
  task migrate_all: [:undo_last_import, :get_all_items, :import_all]
end
