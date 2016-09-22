CurationConcerns.configure do |config|
  # Location on local file system where derivatives will be stored.
  # If you use a multi-server architecture, this MUST be a shared volume.
  config.derivatives_path = ENV['DERIVATIVES_PATH'] || File.join(Rails.root, 'tmp', 'derivatives')

  # Location on local file system where uploaded files will be staged
  # prior to being ingested into the repository or having derivatives generated.
  # If you use a multi-server architecture, this MUST be a shared volume.
  config.working_path = ENV['UPLOAD_PATH'] || File.join(Rails.root, 'tmp', 'uploads')
end
