FactoryBot.define do
  factory :test_order, :class => "Order" do
    arrive_at = Time.zone.local(3000, 1, 1, 12, 0, 0)
    arrive_at_date = Date.new(arrive_at.year, arrive_at.month, arrive_at.day)
    name           { "test_order" }
    quantity       { "100" }
    unit           { "kL" }
    shipment_id    { "1" }
    company_name   { "test_company" }
    facility_id    { "1" }
    oil_id         { "1" }
    user_id        { "1" }
    arrive_at      { arrive_at }
    arrive_at_date { arrive_at_date }
  end

  factory :order do
    sequence(:name) { |n| "TEST_ORDER_NAME#{n}" }
    sequence(:quantity) { |n| n * 100 }
    sequence(:unit) { "kL" }
    sequence(:shipment_id) { rand(1..2) }
    sequence(:company_name) { |n| "TEST_ORDER_COMPANY_NAME#{n}" }
    sequence(:arrive_at) do |n|
      set_year = 3001 + n + rand(0..900)
      Time.zone.local(set_year, 1, 1, 12, 0, 0)
    end
    sequence(:arrive_at_date) do |n|
      set_year = 3001 + n + rand(0..900)
      Date.new(set_year, 1, 1)
    end
    association :facility, factory: :facility
    association :oil, factory: :oil
    association :user, factory: :user

    trait :invalid do
      sequence(:name) { nil }
    end
  end
end
