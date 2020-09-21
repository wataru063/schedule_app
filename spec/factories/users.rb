FactoryBot.define do
  factory :test_user, :class => "User" do
    name { "test_user" }
    email { 'test@test.com' }
    password { 'test00' }
    password_confirmation { 'test00' }
    category_id { '6' }

    after(:create) do |user|
      create_list(:order, 3, user_id: user.id, oil_id: 1, facility_id: 1)
      create_list(:construction, 2, user_id: user.id, oil_id: 1, facility_id: 1)
    end
  end

  factory :guest_user, :class => "User" do
    name { "guest_user" }
    email { 'guestuser@example.com' }
    password { 'guestuser' }
    password_confirmation { 'guestuser' }
    category_id { '6' }

    after(:create) do |user|
      create_list(:order, 3, user_id: user.id, oil_id: 1, facility_id: 1)
      create_list(:construction, 2, user_id: user.id, oil_id: 1, facility_id: 1)
    end
  end


  factory :user do
    sequence(:id) { rand(10000..99999) }
    sequence(:name) { |n| "TEST_NAME#{n}" }
    sequence(:email) { |n| "TEST#{n}@example.com" }
    sequence(:password) { |n| "password" }
    sequence(:password_confirmation) { |n| "password" }
    sequence(:category_id) { |n| rand(1..6) }

    trait :invalid do
      sequence(:name) { nil }
    end

    after(:create) do |user|
      create_list(:order, 3, user_id: user.id)
      create_list(:construction, 2, user_id: user.id)
    end
  end
end
