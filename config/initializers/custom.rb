# Initializer contains miscellaneous custom application configuration settings

# settings from environment
Rails.application.config.x.import = Hashie::Mash.new(
  storage_path: ENV['IMPORT_PATH'] || File.join(Rails.root, 'tmp', 'imports'),
  base_path: ENV['FEDORA_NFS_UPLOAD_PATH'] || Rails.root
)

Rails.application.config.x.iiif = Hashie::Mash.new(
  base_url: ENV['LORIS_SERVER_URI'] || 'http://localhost/iiif/'
)

Rails.application.config.x.feedback_url = ENV['FEEDBACK_FORM_URL']
Rails.application.config.x.base_url = ENV['BASE_URL'] || 'http://localhost/'

Rails.application.config.x.finding_aid_base = ENV['FINDING_AID_BASE'] || 'https://library.osu.edu/finding-aids/ead/'
