FactoryBot.define do
  factory :test_construction, :class => "Construction" do
    start_at = Time.zone.local(2100, 1, 1, 12, 0, 0)
    start_at_date = Date.new(2100, 1, 1)
    end_at = Time.zone.local(2100, 2, 1, 12, 0, 0)
    end_at_date = Date.new(2100, 2, 1)
    name          { "test_construction" }
    notice        { "test_notice" }
    status_id     { "1" }
    facility_id   { "1" }
    oil_id        { "1" }
    category_id   { "1" }
    user_id       { "1" }
    start_at      { start_at }
    start_at_date { start_at_date }
    end_at        { end_at }
    end_at_date   { end_at_date }
    association :facility, factory: :facility
    association :oil, factory: :oil
    association :user, factory: :user
  end

  factory :construction do
    sequence(:id) { rand(10000..99999) }
    sequence(:name) { |n| "TEST_CONSTRUCTION_NAME#{n}" }
    sequence(:notice) { |n| "TEST_NOTICE#{n}" }
    sequence(:status_id) { "1" }
    sequence(:facility_id) { rand(1..5) }
    sequence(:oil_id) { "1" }
    sequence(:category_id) { "1" }
    sequence(:user_id) { "1" }
    sequence(:start_at) do |n|
      set_year = 2100 + n
      Time.zone.local(set_year, 1, 1, 12, 0, 0)
    end
    sequence(:start_at_date) do |n|
      set_year = 2100 + n
      Date.new(set_year, 1, 1)
    end
    sequence(:end_at) do |n|
      set_year = 2100 + n
      Time.zone.local(set_year, 2, 1, 12, 0, 0)
    end
    sequence(:end_at_date) do |n|
      set_year = 2100 + n
      Date.new(set_year, 2, 1)
    end
    association :facility, factory: :facility
    association :oil, factory: :oil
    association :user, factory: :user

    trait :invalid do
      sequence(:name) { nil }
    end
  end
end
