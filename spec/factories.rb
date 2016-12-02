FactoryGirl.define do
  fixture_path = File.expand_path('../fixtures', __FILE__)

  factory :osul_import_imported_item, class: 'Osul::Import::ImportedItem' do
    fid "MyString"
  end

  factory :osul_import_item, class: 'Osul::Import::Item' do
    fid "MyString"
  end

  factory :generic_work, aliases: [:work, :private_generic_work] do
    transient do
      user { create(:user, email: 'depositor@example.com') }
    end

    title ['Test title']
    visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
    unit { create(:unit).key }

    before(:create) do |work, evaluator|
      work.apply_depositor_metadata(evaluator.user.user_key)
    end

    factory :public_generic_work, traits: [:public]

    trait :public do
      visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    end

    trait :without_validations do
      to_create {|instance| instance.save(validate: false) }
    end

    trait :with_image do
      before(:create) do |work, evaluator|
        work.ordered_members << create(:file_set, :image, user: evaluator.user, title: ['An image'], visibility: work.visibility)
        work.representative_id = work.members[0].id
      end
    end

    trait :with_pdf do
      before(:create) do |work, evaluator|
        work.ordered_members << create(:file_set, :pdf, user: evaluator.user, title: ['A PDF'], visibility: work.visibility)
        work.representative_id = work.members[0].id
      end
    end
  end

  factory :file_set do
    transient do
      user { create(:user) }
      content nil
    end

    after(:create) do |file, evaluator|
      if evaluator.content
        Hydra::Works::UploadFileToFileSet.call(file, evaluator.content)
      end
    end

    after(:build) do |file, evaluator|
      file.apply_depositor_metadata(evaluator.user.user_key)
    end

    trait :image do
      content File.open(File.join(fixture_path, "dice.png"))

      after(:stub) do |file|
        allow(file).to receive(:mime_type).and_return 'image/png'
      end
    end

    trait :pdf do
      content File.open(File.join(fixture_path, "document.pdf"))

      after(:stub) do |file|
        allow(file).to receive(:mime_type).and_return 'application/pdf'
      end
    end
  end

  factory :unit do
    name "My Unit"
    key "myunit"
    initialize_with { Unit.find_or_create_by(key: key)}

    trait :allow_duplicate do
      initialize_with { new }
    end
  end

  factory :collection do
    transient do
      user { create(:user) }
    end

    before(:create) do |collection, evaluator|
      collection.apply_depositor_metadata(evaluator.user.user_key)
    end

    title ['My Collection']

    trait :public do
      visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    end

    trait :private do
      visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
    end

    trait :without_validations do
      to_create {|instance| instance.save(validate: false) }
    end
  end

  factory :featured_collection do
  end

  factory :measurement, class: 'Osul::VRA::Measurement' do
    measurement '22'
    measurement_unit 'cm'
    measurement_type 'height'
  end

  factory :material, class: 'Osul::VRA::Material' do
    material 'paper'
    material_type 'backing'
  end

  factory :identity do
    uid "test@example.com"
    provider "myprovider"
    user
  end

  factory :user do
    transient do
      unit nil
    end

    initialize_with { User.find_or_create_by(email: email)}

    email 'test@example.com'
    password 'password'

    factory :admin_user do
      admin true
    end

    trait :allow_duplicate do
      initialize_with { new }
    end

    after(:create) do |user, evaluator|
      create(:membership, unit: evaluator.unit, user: user) if evaluator.unit
    end
  end

  factory :membership do
    unit
    user
    level Membership::MANAGER_LEVEL
  end

  factory :import, aliases: [:simple_import] do
    name "My Import"
    includes_headers true
    server_import_location_name "/images/"
    import_type "Generic"
    rights "http://creativecommons.org/licenses/by/3.0/us/"
    preservation_level "Preservation Master"
    visibility "restricted"

    transient do
      csv_filename 'images.csv'
      mappings do
        { "0" => { "id" => (ImportFieldMapping.last.id - 30).to_s, "value" => ["", "0"] },
          "1" => { "id" => (ImportFieldMapping.last.id - 29).to_s, "value" => ["", "1"] },
          "2" => { "id" => (ImportFieldMapping.last.id - 28).to_s, "value" => ["", "11"] },
          "3" => { "id" => (ImportFieldMapping.last.id - 27).to_s, "value" => [""] },
          "4" => { "id" => (ImportFieldMapping.last.id - 26).to_s, "value" => [""] },
          "5" => { "id" => (ImportFieldMapping.last.id - 25).to_s, "value" => ["", "13"] },
          "6" => { "id" => (ImportFieldMapping.last.id - 24).to_s, "value" => ["", "12"] },
          "7" => { "id" => (ImportFieldMapping.last.id - 23).to_s, "value" => [""] },
          "8" => { "id" => (ImportFieldMapping.last.id - 22).to_s, "value" => ["", "2"] },
          "9" => { "id" => (ImportFieldMapping.last.id - 21).to_s, "value" => ["", "3", "4", "5"] },
          "10" => { "id" => (ImportFieldMapping.last.id - 20).to_s, "value" => [""] },
          "11" => { "id" => (ImportFieldMapping.last.id - 19).to_s, "value" => [""] },
          "12" => { "id" => (ImportFieldMapping.last.id - 18).to_s, "value" => ["", "6", "7"] },
          "13" => { "id" => (ImportFieldMapping.last.id - 17).to_s, "value" => [""] },
          "14" => { "id" => (ImportFieldMapping.last.id - 16).to_s, "value" => [""] },
          "15" => { "id" => (ImportFieldMapping.last.id - 15).to_s, "value" => [""] },
          "16" => { "id" => (ImportFieldMapping.last.id - 14).to_s, "value" => [""] },
          "17" => { "id" => (ImportFieldMapping.last.id - 13).to_s, "value" => [""] },
          "18" => { "id" => (ImportFieldMapping.last.id - 12).to_s, "value" => [""] },
          "19" => { "id" => (ImportFieldMapping.last.id - 11).to_s, "value" => [""] },
          "20" => { "id" => (ImportFieldMapping.last.id - 10).to_s, "value" => [""] },
          "21" => { "id" => (ImportFieldMapping.last.id - 9).to_s, "value" => [""] },
          "22" => { "id" => (ImportFieldMapping.last.id - 8).to_s, "value" => [""] },
          "23" => { "id" => (ImportFieldMapping.last.id - 7).to_s, "value" => [""] },
          "24" => { "id" => (ImportFieldMapping.last.id - 6).to_s, "value" => ["", "9", "10"] },
          "25" => { "id" => (ImportFieldMapping.last.id - 5).to_s, "value" => ["", "8"] },
          "26" => { "id" => (ImportFieldMapping.last.id - 4).to_s, "value" => [""] },
          "27" => { "id" => (ImportFieldMapping.last.id - 3).to_s, "value" => [""] },
          "28" => { "id" => (ImportFieldMapping.last.id - 2).to_s, "value" => [""] },
          "29" => { "id" => (ImportFieldMapping.last.id - 1).to_s, "value" => [""] },
          "30" => { "id" => ImportFieldMapping.last.id.to_s, "value" => [""] } }
      end
    end

    before(:create) do |import, evaluator|
      import.unit = create(:unit) unless import.unit.present?
      uploaded_file = ActionDispatch::Http::UploadedFile.new(filename: evaluator.csv_filename, content_type: "text/csv", tempfile: File.new("#{Rails.root}/spec/fixtures/#{evaluator.csv_filename}"))
      uploaded_file.content_type = "text/csv"
      import.csv = uploaded_file
    end

    trait :with_field_mappings do
      after(:create) do |import, evaluator|
        ImportFieldMapping.initiate_mappings(import)
        import.update("import_field_mappings_attributes" => evaluator.mappings)
        import.validate_import_mappings
      end
    end

    factory :complex_import do
      transient do
        csv_filename 'images_complex.csv'
        mappings do
          { "0" => { "id" => (ImportFieldMapping.last.id - 30).to_s, "value" => ["", "0"] },
            "1" => { "id" => (ImportFieldMapping.last.id - 29).to_s, "value" => ["", "1"] },
            "2" => { "id" => (ImportFieldMapping.last.id - 28).to_s, "value" => ["", "11"] },
            "3" => { "id" => (ImportFieldMapping.last.id - 27).to_s, "value" => ["", "13"] },
            "4" => { "id" => (ImportFieldMapping.last.id - 26).to_s, "value" => ["", "14"] },
            "5" => { "id" => (ImportFieldMapping.last.id - 25).to_s, "value" => [""] },
            "6" => { "id" => (ImportFieldMapping.last.id - 24).to_s, "value" => ["", "12"] },
            "7" => { "id" => (ImportFieldMapping.last.id - 23).to_s, "value" => [""] },
            "8" => { "id" => (ImportFieldMapping.last.id - 22).to_s, "value" => ["", "2"] },
            "9" => { "id" => (ImportFieldMapping.last.id - 21).to_s, "value" => ["", "3", "4", "5"] },
            "10" => { "id" => (ImportFieldMapping.last.id - 20).to_s, "value" => [""] },
            "11" => { "id" => (ImportFieldMapping.last.id - 19).to_s, "value" => [""] },
            "12" => { "id" => (ImportFieldMapping.last.id - 18).to_s, "value" => ["", "6", "7"] },
            "13" => { "id" => (ImportFieldMapping.last.id - 17).to_s, "value" => [""] },
            "14" => { "id" => (ImportFieldMapping.last.id - 16).to_s, "value" => [""] },
            "15" => { "id" => (ImportFieldMapping.last.id - 15).to_s, "value" => [""] },
            "16" => { "id" => (ImportFieldMapping.last.id - 14).to_s, "value" => [""] },
            "17" => { "id" => (ImportFieldMapping.last.id - 13).to_s, "value" => [""] },
            "18" => { "id" => (ImportFieldMapping.last.id - 12).to_s, "value" => [""] },
            "19" => { "id" => (ImportFieldMapping.last.id - 11).to_s, "value" => [""] },
            "20" => { "id" => (ImportFieldMapping.last.id - 10).to_s, "value" => [""] },
            "21" => { "id" => (ImportFieldMapping.last.id - 9).to_s, "value" => [""] },
            "22" => { "id" => (ImportFieldMapping.last.id - 8).to_s, "value" => [""] },
            "23" => { "id" => (ImportFieldMapping.last.id - 7).to_s, "value" => [""] },
            "24" => { "id" => (ImportFieldMapping.last.id - 6).to_s, "value" => ["", "9", "10"] },
            "25" => { "id" => (ImportFieldMapping.last.id - 5).to_s, "value" => ["", "8"] },
            "26" => { "id" => (ImportFieldMapping.last.id - 4).to_s, "value" => [""] },
            "27" => { "id" => (ImportFieldMapping.last.id - 3).to_s, "value" => [""] },
            "28" => { "id" => (ImportFieldMapping.last.id - 2).to_s, "value" => [""] },
            "29" => { "id" => (ImportFieldMapping.last.id - 1).to_s, "value" => [""] },
            "30" => { "id" => ImportFieldMapping.last.id.to_s, "value" => [""] } }
        end
      end
    end

    factory :complex_orphans do
      transient do
        csv_filename 'images_complex_orphans.csv'
        mappings do
          { "0" => { "id" => (ImportFieldMapping.last.id - 30).to_s, "value" => ["", "0"] },
            "1" => { "id" => (ImportFieldMapping.last.id - 29).to_s, "value" => ["", "1"] },
            "2" => { "id" => (ImportFieldMapping.last.id - 28).to_s, "value" => ["", "11"] },
            "3" => { "id" => (ImportFieldMapping.last.id - 27).to_s, "value" => ["", "13"] },
            "4" => { "id" => (ImportFieldMapping.last.id - 26).to_s, "value" => ["", "14"] },
            "5" => { "id" => (ImportFieldMapping.last.id - 25).to_s, "value" => [""] },
            "6" => { "id" => (ImportFieldMapping.last.id - 24).to_s, "value" => ["", "12"] },
            "7" => { "id" => (ImportFieldMapping.last.id - 23).to_s, "value" => [""] },
            "8" => { "id" => (ImportFieldMapping.last.id - 22).to_s, "value" => ["", "2"] },
            "9" => { "id" => (ImportFieldMapping.last.id - 21).to_s, "value" => ["", "3", "4", "5"] },
            "10" => { "id" => (ImportFieldMapping.last.id - 20).to_s, "value" => [""] },
            "11" => { "id" => (ImportFieldMapping.last.id - 19).to_s, "value" => [""] },
            "12" => { "id" => (ImportFieldMapping.last.id - 18).to_s, "value" => ["", "6", "7"] },
            "13" => { "id" => (ImportFieldMapping.last.id - 17).to_s, "value" => [""] },
            "14" => { "id" => (ImportFieldMapping.last.id - 16).to_s, "value" => [""] },
            "15" => { "id" => (ImportFieldMapping.last.id - 15).to_s, "value" => [""] },
            "16" => { "id" => (ImportFieldMapping.last.id - 14).to_s, "value" => [""] },
            "17" => { "id" => (ImportFieldMapping.last.id - 13).to_s, "value" => [""] },
            "18" => { "id" => (ImportFieldMapping.last.id - 12).to_s, "value" => [""] },
            "19" => { "id" => (ImportFieldMapping.last.id - 11).to_s, "value" => [""] },
            "20" => { "id" => (ImportFieldMapping.last.id - 10).to_s, "value" => [""] },
            "21" => { "id" => (ImportFieldMapping.last.id - 9).to_s, "value" => [""] },
            "22" => { "id" => (ImportFieldMapping.last.id - 8).to_s, "value" => [""] },
            "23" => { "id" => (ImportFieldMapping.last.id - 7).to_s, "value" => [""] },
            "24" => { "id" => (ImportFieldMapping.last.id - 6).to_s, "value" => ["", "9", "10"] },
            "25" => { "id" => (ImportFieldMapping.last.id - 5).to_s, "value" => ["", "8"] },
            "26" => { "id" => (ImportFieldMapping.last.id - 4).to_s, "value" => [""] },
            "27" => { "id" => (ImportFieldMapping.last.id - 3).to_s, "value" => [""] },
            "28" => { "id" => (ImportFieldMapping.last.id - 2).to_s, "value" => [""] },
            "29" => { "id" => (ImportFieldMapping.last.id - 1).to_s, "value" => [""] },
            "30" => { "id" => ImportFieldMapping.last.id.to_s, "value" => [""] } }
        end
      end
    end
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
        name:  'Test User'
      }
    end
  end
end
