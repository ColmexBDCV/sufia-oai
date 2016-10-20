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
    visibility "authenticated"
    csv_file_name "images.csv"
    csv_content_type "text/csv"
    csv_file_size 440
    csv_updated_at "2016-09-22 14:54:13"

    before(:create) do |import|
      import.unit = create(:unit) unless import.unit.present?
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
