CurationConcerns.configure do |config|
  # Location on local file system where derivatives will be stored.
  # If you use a multi-server architecture, this MUST be a shared volume.
  config.derivatives_path = ENV['DERIVATIVES_PATH'] || File.join(Rails.root, 'tmp', 'derivatives')
end
