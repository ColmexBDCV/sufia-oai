FactoryGirl.define do
  factory :generic_work do
    title ['My Work']
    creator ['Kebe']
    keyword ['witch']
    depositor 'test@example.com'
    unit 'myunit'

    trait :without_validations do
      to_create {|instance| instance.save(validate: false) }
    end
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
