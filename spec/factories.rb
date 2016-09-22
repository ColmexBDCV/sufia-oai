FactoryGirl.define do
  factory :osul_import_imported_item, class: 'Osul::Import::ImportedItem' do
    fid "MyString"
  end
  factory :osul_import_item, class: 'Osul::Import::Item' do
    fid "MyString"
  end

  factory :generic_work do
    title ['My Work']
    creator ['Kebe']
    keyword ['witch']
    unit 'myunit'
  end

  factory :unit do
    name "My Unit"
    key "myunit"
  end

  factory :featured_collection do
  end

  factory :identity do
    uid "test@example.com"
    provider "myprovider"
    user
  end

  factory :user do
    email 'test@example.com'
    password 'password'

    factory :admin_user do
      admin true
    end
  end

  factory :membership do
    unit
    user
    level "Manager"
  end

  factory :import do
    name "My Import"
    includes_headers true
    server_import_location_name "/images/"
    import_type "Generic"
    rights "http://creativecommons.org/licenses/by/3.0/us/"
    preservation_level "Preservation Master"
    visibility "authenticated"
    csv_file_name "images.csv"
    csv_content_type "text/csv"
    csv_file_size 440
    csv_updated_at "2016-09-22 14:54:13"
  end

  factory :imported_record do

  end

  factory :auth_hash, class: OmniAuth::AuthHash do
    skip_create

    provider 'myprovider'
    uid 'test@example.com'

    info do
      {
        email: 'test@example.com',
        name: 'Test User'
      }
    end
  end
end
