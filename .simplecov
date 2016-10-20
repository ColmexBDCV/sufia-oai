SimpleCov.start :rails do
  add_filter '/vendor/hsj/'

  # Ignore all migration models and scripts
  add_filter "/lib/import/"
  add_filter "/app/models/osul/import"
end
