FactoryGirl.define do
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
  end

  factory :membership do
    unit
    user
    level "MyString"
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
