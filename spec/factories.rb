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

    trait :public do
      visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    end
    trait :private

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

    visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE

    trait :public do
      visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    end
    trait :private

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

  csv_columns = {
    type: "0",
    title: "1",
    description: "2",
    keyword1: "3",
    keyword2: "4",
    keyword3: "5",
    visibility: "6",
    subject1: "7",
    subject2: "8",
    measurement: "9",
    material1: "10",
    material2: "11",
    filename: "12",
    creator: "13",
    pid: "14",
    collection: "14",
    cid: "15"
  }

  mapping_keys = {
    resource_type: "0",
    title: "1",
    image_filename: "2",
    pid: "3",
    cid: "4",
    visibility_level: "5",
    collection_name: "6",
    creator: "7",
    orcid: "8",
    contributor: "9",
    description: "10",
    keyword: "11",
    publisher: "12",
    date_created: "13",
    subject: "14",
    language: "15",
    identifier: "16",
    based_near: "17",
    related_url: "18",
    staff_notes: "19",
    spatial: "20",
    alternative: "21",
    temporal: "22",
    format: "23",
    work_type: "24",
    source: "25",
    materials: "26",
    measurements: "27",
    part_of: "28",
    bibliographic_citation: "29",
    provenance: "30",
    collection_identifier: "31",
    handle: "32"
  }

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
        { mapping_keys[:resource_type]          => { "id" => (ImportFieldMapping.last.id - 32).to_s, "value" => ["", csv_columns[:type]] },
          mapping_keys[:title]                  => { "id" => (ImportFieldMapping.last.id - 31).to_s, "value" => ["", csv_columns[:title]] },
          mapping_keys[:image_filename]         => { "id" => (ImportFieldMapping.last.id - 30).to_s, "value" => ["", csv_columns[:filename]] },
          mapping_keys[:pid]                    => { "id" => (ImportFieldMapping.last.id - 29).to_s, "value" => [""] },
          mapping_keys[:cid]                    => { "id" => (ImportFieldMapping.last.id - 28).to_s, "value" => [""] },
          mapping_keys[:visibility_level]       => { "id" => (ImportFieldMapping.last.id - 27).to_s, "value" => ["", csv_columns[:visibility]] },
          mapping_keys[:collection_name]        => { "id" => (ImportFieldMapping.last.id - 26).to_s, "value" => ["", csv_columns[:collection]] },
          mapping_keys[:creator]                => { "id" => (ImportFieldMapping.last.id - 25).to_s, "value" => ["", csv_columns[:creator]] },
          mapping_keys[:orcid]                => { "id" => (ImportFieldMapping.last.id - 24).to_s, "value" => ["", csv_columns[:creator]] },
          mapping_keys[:contributor]            => { "id" => (ImportFieldMapping.last.id - 23).to_s, "value" => [""] },
          mapping_keys[:description]            => { "id" => (ImportFieldMapping.last.id - 22).to_s, "value" => ["", csv_columns[:description]] },
          mapping_keys[:keyword]                => { "id" => (ImportFieldMapping.last.id - 21).to_s, "value" => ["", csv_columns[:keyword1], csv_columns[:keyword2], csv_columns[:keyword3]] },
          mapping_keys[:publisher]              => { "id" => (ImportFieldMapping.last.id - 20).to_s, "value" => [""] },
          mapping_keys[:date_created]           => { "id" => (ImportFieldMapping.last.id - 19).to_s, "value" => [""] },
          mapping_keys[:subject]                => { "id" => (ImportFieldMapping.last.id - 18).to_s, "value" => ["", csv_columns[:subject1], csv_columns[:subject2]] },
          mapping_keys[:language]               => { "id" => (ImportFieldMapping.last.id - 17).to_s, "value" => [""] },
          mapping_keys[:identifier]             => { "id" => (ImportFieldMapping.last.id - 16).to_s, "value" => [""] },
          mapping_keys[:base_near]              => { "id" => (ImportFieldMapping.last.id - 15).to_s, "value" => [""] },
          mapping_keys[:related_url]            => { "id" => (ImportFieldMapping.last.id - 14).to_s, "value" => [""] },
          mapping_keys[:staff_notes]            => { "id" => (ImportFieldMapping.last.id - 13).to_s, "value" => [""] },
          mapping_keys[:spatial]                => { "id" => (ImportFieldMapping.last.id - 12).to_s, "value" => [""] },
          mapping_keys[:alternative]            => { "id" => (ImportFieldMapping.last.id - 11).to_s, "value" => [""] },
          mapping_keys[:temporal]               => { "id" => (ImportFieldMapping.last.id - 10).to_s, "value" => [""] },
          mapping_keys[:format]                 => { "id" => (ImportFieldMapping.last.id - 9).to_s,  "value" => [""] },
          mapping_keys[:work_type]              => { "id" => (ImportFieldMapping.last.id - 8).to_s,  "value" => [""] },
          mapping_keys[:source]                 => { "id" => (ImportFieldMapping.last.id - 7).to_s,  "value" => [""] },
          mapping_keys[:materials]              => { "id" => (ImportFieldMapping.last.id - 6).to_s,  "value" => ["", csv_columns[:material1], csv_columns[:material2]] },
          mapping_keys[:measurements]           => { "id" => (ImportFieldMapping.last.id - 5).to_s,  "value" => ["", csv_columns[:measurement]] },
          mapping_keys[:part_of]                => { "id" => (ImportFieldMapping.last.id - 4).to_s,  "value" => [""] },
          mapping_keys[:bibliographic_citation] => { "id" => (ImportFieldMapping.last.id - 3).to_s,  "value" => [""] },
          mapping_keys[:provenance]             => { "id" => (ImportFieldMapping.last.id - 2).to_s,  "value" => [""] },
          mapping_keys[:collection_identifier]  => { "id" => (ImportFieldMapping.last.id - 1).to_s,  "value" => [""] },
          mapping_keys[:handle]                 => { "id" => ImportFieldMapping.last.id.to_s,        "value" => [""] } }
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
      visibility "open"
      transient do
        csv_filename 'images_complex.csv'
        mappings do
          { mapping_keys[:resource_type]          => { "id" => (ImportFieldMapping.last.id - 32).to_s, "value" => ["", csv_columns[:type]] },
            mapping_keys[:title]                  => { "id" => (ImportFieldMapping.last.id - 31).to_s, "value" => ["", csv_columns[:title]] },
            mapping_keys[:image_filename]         => { "id" => (ImportFieldMapping.last.id - 30).to_s, "value" => ["", csv_columns[:filename]] },
            mapping_keys[:pid]                    => { "id" => (ImportFieldMapping.last.id - 29).to_s, "value" => ["", csv_columns[:pid]] },
            mapping_keys[:cid]                    => { "id" => (ImportFieldMapping.last.id - 28).to_s, "value" => ["", csv_columns[:cid]] },
            mapping_keys[:visibility_level]       => { "id" => (ImportFieldMapping.last.id - 27).to_s, "value" => ["", csv_columns[:visibility]] },
            mapping_keys[:collection_name]        => { "id" => (ImportFieldMapping.last.id - 26).to_s, "value" => [""] },
            mapping_keys[:creator]                => { "id" => (ImportFieldMapping.last.id - 25).to_s, "value" => ["", csv_columns[:creator]] },
            mapping_keys[:contributor]            => { "id" => (ImportFieldMapping.last.id - 23).to_s, "value" => [""] },
            mapping_keys[:description]            => { "id" => (ImportFieldMapping.last.id - 22).to_s, "value" => ["", csv_columns[:description]] },
            mapping_keys[:keyword]                => { "id" => (ImportFieldMapping.last.id - 21).to_s, "value" => ["", csv_columns[:keyword1], csv_columns[:keyword2], csv_columns[:keyword3]] },
            mapping_keys[:publisher]              => { "id" => (ImportFieldMapping.last.id - 20).to_s, "value" => [""] },
            mapping_keys[:date_created]           => { "id" => (ImportFieldMapping.last.id - 19).to_s, "value" => [""] },
            mapping_keys[:subject]                => { "id" => (ImportFieldMapping.last.id - 18).to_s, "value" => ["", csv_columns[:subject1], csv_columns[:subject2]] },
            mapping_keys[:language]               => { "id" => (ImportFieldMapping.last.id - 17).to_s, "value" => [""] },
            mapping_keys[:identifier]             => { "id" => (ImportFieldMapping.last.id - 16).to_s, "value" => [""] },
            mapping_keys[:base_near]              => { "id" => (ImportFieldMapping.last.id - 15).to_s, "value" => [""] },
            mapping_keys[:related_url]            => { "id" => (ImportFieldMapping.last.id - 14).to_s, "value" => [""] },
            mapping_keys[:staff_notes]            => { "id" => (ImportFieldMapping.last.id - 13).to_s, "value" => [""] },
            mapping_keys[:spatial]                => { "id" => (ImportFieldMapping.last.id - 12).to_s, "value" => [""] },
            mapping_keys[:alternative]            => { "id" => (ImportFieldMapping.last.id - 11).to_s, "value" => [""] },
            mapping_keys[:temporal]               => { "id" => (ImportFieldMapping.last.id - 10).to_s, "value" => [""] },
            mapping_keys[:format]                 => { "id" => (ImportFieldMapping.last.id - 9).to_s,  "value" => [""] },
            mapping_keys[:work_type]              => { "id" => (ImportFieldMapping.last.id - 8).to_s,  "value" => [""] },
            mapping_keys[:source]                 => { "id" => (ImportFieldMapping.last.id - 7).to_s,  "value" => [""] },
            mapping_keys[:materials]              => { "id" => (ImportFieldMapping.last.id - 6).to_s,  "value" => ["", csv_columns[:material1], csv_columns[:material2]] },
            mapping_keys[:measurements]           => { "id" => (ImportFieldMapping.last.id - 5).to_s,  "value" => ["", csv_columns[:measurement]] },
            mapping_keys[:part_of]                => { "id" => (ImportFieldMapping.last.id - 4).to_s,  "value" => [""] },
            mapping_keys[:bibliographic_citation] => { "id" => (ImportFieldMapping.last.id - 3).to_s,  "value" => [""] },
            mapping_keys[:provenance]             => { "id" => (ImportFieldMapping.last.id - 2).to_s,  "value" => [""] },
            mapping_keys[:collection_identifier]  => { "id" => (ImportFieldMapping.last.id - 1).to_s,  "value" => [""] },
            mapping_keys[:handle]                 => { "id" => ImportFieldMapping.last.id.to_s,        "value" => [""] } }
        end
      end
    end

    factory :complex_orphans do
      visibility "authenticated"
      transient do
        csv_filename 'images_complex_orphans.csv'
        mappings do
          { mapping_keys[:resource_type]           => { "id" => (ImportFieldMapping.last.id - 32).to_s, "value" => ["", csv_columns[:type]] },
            mapping_keys[:title]                   => { "id" => (ImportFieldMapping.last.id - 31).to_s, "value" => ["", csv_columns[:title]] },
            mapping_keys[:image_filename]          => { "id" => (ImportFieldMapping.last.id - 30).to_s, "value" => ["", csv_columns[:filename]] },
            mapping_keys[:pid]                     => { "id" => (ImportFieldMapping.last.id - 29).to_s, "value" => ["", csv_columns[:pid]] },
            mapping_keys[:cid]                     => { "id" => (ImportFieldMapping.last.id - 28).to_s, "value" => ["", csv_columns[:cid]] },
            mapping_keys[:visibility_level]        => { "id" => (ImportFieldMapping.last.id - 27).to_s, "value" => ["", csv_columns[:visibility]] },
            mapping_keys[:collection_name]         => { "id" => (ImportFieldMapping.last.id - 26).to_s, "value" => [""] },
            mapping_keys[:creator]                 => { "id" => (ImportFieldMapping.last.id - 25).to_s, "value" => ["", csv_columns[:creator]] },
            mapping_keys[:contributor]             => { "id" => (ImportFieldMapping.last.id - 23).to_s, "value" => [""] },
            mapping_keys[:description]             => { "id" => (ImportFieldMapping.last.id - 22).to_s, "value" => ["", csv_columns[:description]] },
            mapping_keys[:keyword]                 => { "id" => (ImportFieldMapping.last.id - 21).to_s, "value" => ["", csv_columns[:keyword1], csv_columns[:keyword2], csv_columns[:keyword3]] },
            mapping_keys[:publisher]               => { "id" => (ImportFieldMapping.last.id - 20).to_s, "value" => [""] },
            mapping_keys[:date_created]            => { "id" => (ImportFieldMapping.last.id - 19).to_s, "value" => [""] },
            mapping_keys[:subject]                 => { "id" => (ImportFieldMapping.last.id - 18).to_s, "value" => ["", csv_columns[:subject1], csv_columns[:subject2]] },
            mapping_keys[:language]                => { "id" => (ImportFieldMapping.last.id - 17).to_s, "value" => [""] },
            mapping_keys[:identifier]              => { "id" => (ImportFieldMapping.last.id - 16).to_s, "value" => [""] },
            mapping_keys[:base_near]               => { "id" => (ImportFieldMapping.last.id - 15).to_s, "value" => [""] },
            mapping_keys[:related_url]             => { "id" => (ImportFieldMapping.last.id - 14).to_s, "value" => [""] },
            mapping_keys[:staff_notes]             => { "id" => (ImportFieldMapping.last.id - 13).to_s, "value" => [""] },
            mapping_keys[:spatial]                 => { "id" => (ImportFieldMapping.last.id - 12).to_s, "value" => [""] },
            mapping_keys[:alternative]             => { "id" => (ImportFieldMapping.last.id - 11).to_s, "value" => [""] },
            mapping_keys[:temporal]                => { "id" => (ImportFieldMapping.last.id - 10).to_s, "value" => [""] },
            mapping_keys[:format]                  => { "id" => (ImportFieldMapping.last.id - 9).to_s,  "value" => [""] },
            mapping_keys[:work_type]               => { "id" => (ImportFieldMapping.last.id - 8).to_s,  "value" => [""] },
            mapping_keys[:source]                  => { "id" => (ImportFieldMapping.last.id - 7).to_s,  "value" => [""] },
            mapping_keys[:materials]               => { "id" => (ImportFieldMapping.last.id - 6).to_s,  "value" => ["", csv_columns[:material1], csv_columns[:material2]] },
            mapping_keys[:measurements]            => { "id" => (ImportFieldMapping.last.id - 5).to_s,  "value" => ["", csv_columns[:measurement]] },
            mapping_keys[:part_of]                 => { "id" => (ImportFieldMapping.last.id - 4).to_s,  "value" => [""] },
            mapping_keys[:bibliographic_citation]  => { "id" => (ImportFieldMapping.last.id - 3).to_s,  "value" => [""] },
            mapping_keys[:provenance]              => { "id" => (ImportFieldMapping.last.id - 2).to_s,  "value" => [""] },
            mapping_keys[:collection_identifier]   => { "id" => (ImportFieldMapping.last.id - 1).to_s,  "value" => [""] },
            mapping_keys[:handle]                  => { "id" => ImportFieldMapping.last.id.to_s,        "value" => [""] } }
        end
      end
    end

    factory :simple_with_blank_rows do
      visibility "open"
      transient do
        csv_filename 'images_with_blanks.csv'
        mappings do
          { mapping_keys[:resource_type]          => { "id" => (ImportFieldMapping.last.id - 32).to_s, "value" => ["", csv_columns[:type]] },
            mapping_keys[:title]                  => { "id" => (ImportFieldMapping.last.id - 31).to_s, "value" => ["", csv_columns[:title]] },
            mapping_keys[:image_filename]         => { "id" => (ImportFieldMapping.last.id - 30).to_s, "value" => ["", csv_columns[:filename]] },
            mapping_keys[:pid]                    => { "id" => (ImportFieldMapping.last.id - 29).to_s, "value" => [""] },
            mapping_keys[:cid]                    => { "id" => (ImportFieldMapping.last.id - 28).to_s, "value" => [""] },
            mapping_keys[:visibility_level]       => { "id" => (ImportFieldMapping.last.id - 27).to_s, "value" => ["", csv_columns[:visibility]] },
            mapping_keys[:collection_name]        => { "id" => (ImportFieldMapping.last.id - 26).to_s, "value" => ["", csv_columns[:collection]] },
            mapping_keys[:creator]                => { "id" => (ImportFieldMapping.last.id - 25).to_s, "value" => ["", csv_columns[:creator]] },
            mapping_keys[:contributor]            => { "id" => (ImportFieldMapping.last.id - 23).to_s, "value" => [""] },
            mapping_keys[:description]            => { "id" => (ImportFieldMapping.last.id - 22).to_s, "value" => ["", csv_columns[:description]] },
            mapping_keys[:keyword]                => { "id" => (ImportFieldMapping.last.id - 21).to_s, "value" => ["", csv_columns[:keyword1], csv_columns[:keyword2], csv_columns[:keyword3]] },
            mapping_keys[:publisher]              => { "id" => (ImportFieldMapping.last.id - 20).to_s, "value" => [""] },
            mapping_keys[:date_created]           => { "id" => (ImportFieldMapping.last.id - 19).to_s, "value" => [""] },
            mapping_keys[:subject]                => { "id" => (ImportFieldMapping.last.id - 18).to_s, "value" => ["", csv_columns[:subject1], csv_columns[:subject2]] },
            mapping_keys[:language]               => { "id" => (ImportFieldMapping.last.id - 17).to_s, "value" => [""] },
            mapping_keys[:identifier]             => { "id" => (ImportFieldMapping.last.id - 16).to_s, "value" => [""] },
            mapping_keys[:base_near]              => { "id" => (ImportFieldMapping.last.id - 15).to_s, "value" => [""] },
            mapping_keys[:related_url]            => { "id" => (ImportFieldMapping.last.id - 14).to_s, "value" => [""] },
            mapping_keys[:staff_notes]            => { "id" => (ImportFieldMapping.last.id - 13).to_s, "value" => [""] },
            mapping_keys[:spatial]                => { "id" => (ImportFieldMapping.last.id - 12).to_s, "value" => [""] },
            mapping_keys[:alternative]            => { "id" => (ImportFieldMapping.last.id - 11).to_s, "value" => [""] },
            mapping_keys[:temporal]               => { "id" => (ImportFieldMapping.last.id - 10).to_s, "value" => [""] },
            mapping_keys[:format]                 => { "id" => (ImportFieldMapping.last.id - 9).to_s,  "value" => [""] },
            mapping_keys[:work_type]              => { "id" => (ImportFieldMapping.last.id - 8).to_s,  "value" => [""] },
            mapping_keys[:source]                 => { "id" => (ImportFieldMapping.last.id - 7).to_s,  "value" => [""] },
            mapping_keys[:materials]              => { "id" => (ImportFieldMapping.last.id - 6).to_s,  "value" => ["", csv_columns[:material1], csv_columns[:material2]] },
            mapping_keys[:measurements]           => { "id" => (ImportFieldMapping.last.id - 5).to_s,  "value" => ["", csv_columns[:measurement]] },
            mapping_keys[:part_of]                => { "id" => (ImportFieldMapping.last.id - 4).to_s,  "value" => [""] },
            mapping_keys[:bibliographic_citation] => { "id" => (ImportFieldMapping.last.id - 3).to_s,  "value" => [""] },
            mapping_keys[:provenance]             => { "id" => (ImportFieldMapping.last.id - 2).to_s,  "value" => [""] },
            mapping_keys[:collection_identifier]  => { "id" => (ImportFieldMapping.last.id - 1).to_s,  "value" => [""] },
            mapping_keys[:handle]                 => { "id" => ImportFieldMapping.last.id.to_s,        "value" => [""] } }
        end
      end
    end

    factory :simple_with_orcid do
      name "My Orcid Import"
      includes_headers true
      server_import_location_name "/images/"
      import_type "Generic"
      rights "http://creativecommons.org/licenses/by/3.0/us/"
      preservation_level "Preservation Master"
      visibility "open"
      orcid_csv_columns = {
        title: "0",
        orcid: "1",
        creator: "2",
        type: "3"
      }
      transient do
        csv_filename 'test_simple_orcid.csv'

        mappings do
          { mapping_keys[:resource_type]          => { "id" => (ImportFieldMapping.last.id - 32).to_s, "value" => ["", csv_columns[:type]] },
            mapping_keys[:title]                  => { "id" => (ImportFieldMapping.last.id - 31).to_s, "value" => ["", orcid_csv_columns[:title]] },
            mapping_keys[:image_filename]         => { "id" => (ImportFieldMapping.last.id - 30).to_s, "value" => ["", csv_columns[:filename]] },
            mapping_keys[:pid]                    => { "id" => (ImportFieldMapping.last.id - 29).to_s, "value" => [""] },
            mapping_keys[:cid]                    => { "id" => (ImportFieldMapping.last.id - 28).to_s, "value" => [""] },
            mapping_keys[:visibility_level]       => { "id" => (ImportFieldMapping.last.id - 27).to_s, "value" => ["", csv_columns[:visibility]] },
            mapping_keys[:collection_name]        => { "id" => (ImportFieldMapping.last.id - 26).to_s, "value" => ["", csv_columns[:collection]] },
            mapping_keys[:creator]                => { "id" => (ImportFieldMapping.last.id - 25).to_s, "value" => ["", orcid_csv_columns[:creator]] },
            mapping_keys[:orcid]                => { "id" => (ImportFieldMapping.last.id - 24).to_s, "value" => ["", orcid_csv_columns[:orcid]] },
            mapping_keys[:contributor]            => { "id" => (ImportFieldMapping.last.id - 23).to_s, "value" => [""] },
            mapping_keys[:description]            => { "id" => (ImportFieldMapping.last.id - 22).to_s, "value" => ["", csv_columns[:description]] },
            mapping_keys[:keyword]                => { "id" => (ImportFieldMapping.last.id - 21).to_s, "value" => ["", csv_columns[:keyword1], csv_columns[:keyword2], csv_columns[:keyword3]] },
            mapping_keys[:publisher]              => { "id" => (ImportFieldMapping.last.id - 20).to_s, "value" => [""] },
            mapping_keys[:date_created]           => { "id" => (ImportFieldMapping.last.id - 19).to_s, "value" => [""] },
            mapping_keys[:subject]                => { "id" => (ImportFieldMapping.last.id - 18).to_s, "value" => ["", csv_columns[:subject1], csv_columns[:subject2]] },
            mapping_keys[:language]               => { "id" => (ImportFieldMapping.last.id - 17).to_s, "value" => [""] },
            mapping_keys[:identifier]             => { "id" => (ImportFieldMapping.last.id - 16).to_s, "value" => [""] },
            mapping_keys[:base_near]              => { "id" => (ImportFieldMapping.last.id - 15).to_s, "value" => [""] },
            mapping_keys[:related_url]            => { "id" => (ImportFieldMapping.last.id - 14).to_s, "value" => [""] },
            mapping_keys[:staff_notes]            => { "id" => (ImportFieldMapping.last.id - 13).to_s, "value" => [""] },
            mapping_keys[:spatial]                => { "id" => (ImportFieldMapping.last.id - 12).to_s, "value" => [""] },
            mapping_keys[:alternative]            => { "id" => (ImportFieldMapping.last.id - 11).to_s, "value" => [""] },
            mapping_keys[:temporal]               => { "id" => (ImportFieldMapping.last.id - 10).to_s, "value" => [""] },
            mapping_keys[:format]                 => { "id" => (ImportFieldMapping.last.id - 9).to_s,  "value" => [""] },
            mapping_keys[:work_type]              => { "id" => (ImportFieldMapping.last.id - 8).to_s,  "value" => [""] },
            mapping_keys[:source]                 => { "id" => (ImportFieldMapping.last.id - 7).to_s,  "value" => [""] },
            mapping_keys[:materials]              => { "id" => (ImportFieldMapping.last.id - 6).to_s,  "value" => ["", csv_columns[:material1], csv_columns[:material2]] },
            mapping_keys[:measurements]           => { "id" => (ImportFieldMapping.last.id - 5).to_s,  "value" => ["", csv_columns[:measurement]] },
            mapping_keys[:part_of]                => { "id" => (ImportFieldMapping.last.id - 4).to_s,  "value" => [""] },
            mapping_keys[:bibliographic_citation] => { "id" => (ImportFieldMapping.last.id - 3).to_s,  "value" => [""] },
            mapping_keys[:provenance]             => { "id" => (ImportFieldMapping.last.id - 2).to_s,  "value" => [""] },
            mapping_keys[:collection_identifier]  => { "id" => (ImportFieldMapping.last.id - 1).to_s,  "value" => [""] },
            mapping_keys[:handle]                 => { "id" => ImportFieldMapping.last.id.to_s,        "value" => [""] } }
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
