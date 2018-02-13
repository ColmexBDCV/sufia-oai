# Initializer contains miscellaneous custom application configuration settings

# settings from environment: adding root to paths for dev and test
if Rails.env == "test"
  storage_path = "#{Rails.root}#{ENV['TEST_IMPORT_PATH']}"
  base_path = "#{Rails.root}#{ENV['TEST_FEDORA_NFS_UPLOAD_PATH']}"

  Rails.application.config.import = Hashie::Mash.new(
    storage_path: storage_path,
    base_path: base_path
  )
elsif Rails.env == "development"
  storage_path = "#{Rails.root}#{ENV['IMPORT_PATH']}"
  base_path = "#{Rails.root}#{ENV['FEDORA_NFS_UPLOAD_PATH']}"

  Rails.application.config.import = Hashie::Mash.new(
    storage_path: storage_path,
    base_path: base_path
  )
else
  Rails.application.config.import = Hashie::Mash.new(
  storage_path: ENV['IMPORT_PATH'] || File.join(Rails.root, 'tmp', 'imports'),
  base_path: ENV['FEDORA_NFS_UPLOAD_PATH'] || Rails.root
  )
end

Rails.application.config.x.iiif = Hashie::Mash.new(
  base_url: ENV['LORIS_SERVER_URI'] || 'http://localhost/iiif/'
)

Rails.application.config.feedback_url = ENV['FEEDBACK_FORM_URL']
Rails.application.config.base_url = ENV['BASE_URL'] || 'http://localhost/'

Rails.application.config.finding_aid_base = ENV['FINDING_AID_BASE'] || 'https://library.osu.edu/finding-aids/ead/'
