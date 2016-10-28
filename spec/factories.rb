FactoryGirl.define do
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

    before(:create) do |work, evaluator|
      work.unit = create(:unit).key unless work.unit.present?
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
        work.ordered_members << create(:file_set, :image, user: evaluator.user, title: ['An image'])
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
      after(:build) do |file|
        allow(file).to receive(:mime_type).and_return 'image/tiff'
      end
    end
  end

  factory :unit do
    name "My Unit"
    key "myunit"
  end

  factory :collection do
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

    email 'test@example.com'
    password 'password'

    factory :admin_user do
      admin true
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

  factory :import do
    name "My Import"
    includes_headers true
    server_import_location_name "/images/"
    import_type "Generic"
    rights "http://creativecommons.org/licenses/by/3.0/us/"
    preservation_level "Preservation Master"
    visibility "restricted"

    factory :complex_import do
      before(:create) do |import|
        import.unit = create(:unit) unless import.unit.present?
        uploaded_file = ActionDispatch::Http::UploadedFile.new({:filename => "images_complex.csv", :content_type => "text/csv", :tempfile => File.new("#{Rails.root.to_s}/spec/fixtures/images_complex.csv")})
        uploaded_file.content_type = "text/csv"
        import.csv = uploaded_file
      end

      after(:create) do |import|
        ImportFieldMapping.initiate_mappings(import)
        params = {"import_field_mappings_attributes"=>{
                    "0" =>{"id"=>"#{ImportFieldMapping.last.id-29}", "value"=>["", "13"]},
                    "1" =>{"id"=>"#{ImportFieldMapping.last.id-28}", "value"=>["", "14"]},
                    "2" =>{"id"=>"#{ImportFieldMapping.last.id-27}", "value"=>["", "0"]},
                    "3" =>{"id"=>"#{ImportFieldMapping.last.id-26}", "value"=>["", "1"]},
                    "4" =>{"id"=>"#{ImportFieldMapping.last.id-25}", "value"=>["", "12"]},
                    "5" =>{"id"=>"#{ImportFieldMapping.last.id-24}", "value"=>[""]},
                    "6" =>{"id"=>"#{ImportFieldMapping.last.id-23}", "value"=>["", "2"]},
                    "7" =>{"id"=>"#{ImportFieldMapping.last.id-22}", "value"=>["", "3", "4", "5"]},
                    "8" =>{"id"=>"#{ImportFieldMapping.last.id-21}", "value"=>[""]},
                    "9" =>{"id"=>"#{ImportFieldMapping.last.id-20}", "value"=>[""]},
                    "10"=>{"id"=>"#{ImportFieldMapping.last.id-19}", "value"=>["", "6", "7"]},
                    "11"=>{"id"=>"#{ImportFieldMapping.last.id-18}", "value"=>[""]},
                    "12"=>{"id"=>"#{ImportFieldMapping.last.id-17}", "value"=>[""]},
                    "13"=>{"id"=>"#{ImportFieldMapping.last.id-16}", "value"=>[""]},
                    "14"=>{"id"=>"#{ImportFieldMapping.last.id-15}", "value"=>[""]},
                    "15"=>{"id"=>"#{ImportFieldMapping.last.id-14}", "value"=>[""]},
                    "16"=>{"id"=>"#{ImportFieldMapping.last.id-13}", "value"=>[""]},
                    "17"=>{"id"=>"#{ImportFieldMapping.last.id-12}", "value"=>[""]},
                    "18"=>{"id"=>"#{ImportFieldMapping.last.id-11}", "value"=>[""]},
                    "19"=>{"id"=>"#{ImportFieldMapping.last.id-10}", "value"=>[""]},
                    "20"=>{"id"=>"#{ImportFieldMapping.last.id-9}", "value"=>[""]},
                    "21"=>{"id"=>"#{ImportFieldMapping.last.id-8}", "value"=>[""]},
                    "22"=>{"id"=>"#{ImportFieldMapping.last.id-7}", "value"=>["", "9", "10"]},
                    "23"=>{"id"=>"#{ImportFieldMapping.last.id-6}", "value"=>["", "8"]},
                    "24"=>{"id"=>"#{ImportFieldMapping.last.id-5}", "value"=>[""]},
                    "25"=>{"id"=>"#{ImportFieldMapping.last.id-4}", "value"=>[""]},
                    "26"=>{"id"=>"#{ImportFieldMapping.last.id-3}", "value"=>[""]},
                    "27"=>{"id"=>"#{ImportFieldMapping.last.id-2}", "value"=>[""]},
                    "28"=>{"id"=>"#{ImportFieldMapping.last.id-1}", "value"=>[""]},
                    "29"=>{"id"=>"#{ImportFieldMapping.last.id}", "value"=>["", "11"]}
                 }
               }
        import.update(params)
      end
    end

    factory :complex_orphans do
      before(:create) do |import|
        import.unit = create(:unit) unless import.unit.present?
        uploaded_file = ActionDispatch::Http::UploadedFile.new({:filename => "images_complex_orphans.csv", :content_type => "text/csv", :tempfile => File.new("#{Rails.root.to_s}/spec/fixtures/images_complex_orphans.csv")})
        uploaded_file.content_type = "text/csv"
        import.csv = uploaded_file
      end

      after(:create) do |import|
        ImportFieldMapping.initiate_mappings(import)
        params = {"import_field_mappings_attributes"=>{
                    "0" =>{"id"=>"#{ImportFieldMapping.last.id-29}", "value"=>["", "13"]},
                    "1" =>{"id"=>"#{ImportFieldMapping.last.id-28}", "value"=>["", "14"]},
                    "2" =>{"id"=>"#{ImportFieldMapping.last.id-27}", "value"=>["", "0"]},
                    "3" =>{"id"=>"#{ImportFieldMapping.last.id-26}", "value"=>["", "1"]},
                    "4" =>{"id"=>"#{ImportFieldMapping.last.id-25}", "value"=>["", "12"]},
                    "5" =>{"id"=>"#{ImportFieldMapping.last.id-24}", "value"=>[""]},
                    "6" =>{"id"=>"#{ImportFieldMapping.last.id-23}", "value"=>["", "2"]},
                    "7" =>{"id"=>"#{ImportFieldMapping.last.id-22}", "value"=>["", "3", "4", "5"]},
                    "8" =>{"id"=>"#{ImportFieldMapping.last.id-21}", "value"=>[""]},
                    "9" =>{"id"=>"#{ImportFieldMapping.last.id-20}", "value"=>[""]},
                    "10"=>{"id"=>"#{ImportFieldMapping.last.id-19}", "value"=>["", "6", "7"]},
                    "11"=>{"id"=>"#{ImportFieldMapping.last.id-18}", "value"=>[""]},
                    "12"=>{"id"=>"#{ImportFieldMapping.last.id-17}", "value"=>[""]},
                    "13"=>{"id"=>"#{ImportFieldMapping.last.id-16}", "value"=>[""]},
                    "14"=>{"id"=>"#{ImportFieldMapping.last.id-15}", "value"=>[""]},
                    "15"=>{"id"=>"#{ImportFieldMapping.last.id-14}", "value"=>[""]},
                    "16"=>{"id"=>"#{ImportFieldMapping.last.id-13}", "value"=>[""]},
                    "17"=>{"id"=>"#{ImportFieldMapping.last.id-12}", "value"=>[""]},
                    "18"=>{"id"=>"#{ImportFieldMapping.last.id-11}", "value"=>[""]},
                    "19"=>{"id"=>"#{ImportFieldMapping.last.id-10}", "value"=>[""]},
                    "20"=>{"id"=>"#{ImportFieldMapping.last.id-9}", "value"=>[""]},
                    "21"=>{"id"=>"#{ImportFieldMapping.last.id-8}", "value"=>[""]},
                    "22"=>{"id"=>"#{ImportFieldMapping.last.id-7}", "value"=>["", "9", "10"]},
                    "23"=>{"id"=>"#{ImportFieldMapping.last.id-6}", "value"=>["", "8"]},
                    "24"=>{"id"=>"#{ImportFieldMapping.last.id-5}", "value"=>[""]},
                    "25"=>{"id"=>"#{ImportFieldMapping.last.id-4}", "value"=>[""]},
                    "26"=>{"id"=>"#{ImportFieldMapping.last.id-3}", "value"=>[""]},
                    "27"=>{"id"=>"#{ImportFieldMapping.last.id-2}", "value"=>[""]},
                    "28"=>{"id"=>"#{ImportFieldMapping.last.id-1}", "value"=>[""]},
                    "29"=>{"id"=>"#{ImportFieldMapping.last.id}", "value"=>["", "11"]}
                 }
               }
        import.update(params)
      end
    end

    factory :simple_import do
      before(:create) do |import|
        import.unit = create(:unit) unless import.unit.present?
        uploaded_file = ActionDispatch::Http::UploadedFile.new({:filename => "images.csv", :content_type => "text/csv", :tempfile => File.new("#{Rails.root.to_s}/spec/fixtures/images.csv")})
        uploaded_file.content_type = "text/csv"
        import.csv = uploaded_file
      end

      after(:create) do |import|
        ImportFieldMapping.initiate_mappings(import)
        params = {"import_field_mappings_attributes"=> {
                    "0" =>{"id"=>"#{ImportFieldMapping.last.id-29}", "value"=>[""]},
                    "1" =>{"id"=>"#{ImportFieldMapping.last.id-28}", "value"=>[""]},
                    "2" =>{"id"=>"#{ImportFieldMapping.last.id-27}", "value"=>["", "0"]},
                    "3" =>{"id"=>"#{ImportFieldMapping.last.id-26}", "value"=>["", "1"]},
                    "4" =>{"id"=>"#{ImportFieldMapping.last.id-25}", "value"=>["", "12"]},
                    "5" =>{"id"=>"#{ImportFieldMapping.last.id-24}", "value"=>[""]},
                    "6" =>{"id"=>"#{ImportFieldMapping.last.id-23}", "value"=>["", "2"]},
                    "7" =>{"id"=>"#{ImportFieldMapping.last.id-22}", "value"=>["", "3", "4", "5"]},
                    "8" =>{"id"=>"#{ImportFieldMapping.last.id-21}", "value"=>[""]},
                    "9" =>{"id"=>"#{ImportFieldMapping.last.id-20}", "value"=>[""]},
                    "10"=>{"id"=>"#{ImportFieldMapping.last.id-19}", "value"=>["", "6", "7"]},
                    "11"=>{"id"=>"#{ImportFieldMapping.last.id-18}", "value"=>[""]},
                    "12"=>{"id"=>"#{ImportFieldMapping.last.id-17}", "value"=>[""]},
                    "13"=>{"id"=>"#{ImportFieldMapping.last.id-16}", "value"=>[""]},
                    "14"=>{"id"=>"#{ImportFieldMapping.last.id-15}", "value"=>[""]},
                    "15"=>{"id"=>"#{ImportFieldMapping.last.id-14}", "value"=>[""]},
                    "16"=>{"id"=>"#{ImportFieldMapping.last.id-13}", "value"=>[""]},
                    "17"=>{"id"=>"#{ImportFieldMapping.last.id-12}", "value"=>[""]},
                    "18"=>{"id"=>"#{ImportFieldMapping.last.id-11}", "value"=>[""]},
                    "19"=>{"id"=>"#{ImportFieldMapping.last.id-10}", "value"=>[""]},
                    "20"=>{"id"=>"#{ImportFieldMapping.last.id-9}", "value"=>[""]},
                    "21"=>{"id"=>"#{ImportFieldMapping.last.id-8}", "value"=>[""]},
                    "22"=>{"id"=>"#{ImportFieldMapping.last.id-7}", "value"=>["", "9", "10"]},
                    "23"=>{"id"=>"#{ImportFieldMapping.last.id-6}", "value"=>["", "8"]},
                    "24"=>{"id"=>"#{ImportFieldMapping.last.id-5}", "value"=>[""]},
                    "25"=>{"id"=>"#{ImportFieldMapping.last.id-4}", "value"=>[""]},
                    "26"=>{"id"=>"#{ImportFieldMapping.last.id-3}", "value"=>[""]},
                    "27"=>{"id"=>"#{ImportFieldMapping.last.id-2}", "value"=>[""]},
                    "28"=>{"id"=>"#{ImportFieldMapping.last.id-1}", "value"=>[""]},
                    "29"=>{"id"=>"#{ImportFieldMapping.last.id}", "value"=>["", "11"]}
                  }
                }
        import.update(params)
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
        name: 'Test User'
      }
    end
  end
end
