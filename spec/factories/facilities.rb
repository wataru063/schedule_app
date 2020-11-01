FactoryBot.define do
  factory :test_facility, :class => "Facility" do
    id   { 999 }
    name { "test_facility" }
  end

  factory :facility do
    sequence(:name) { |n| "FACILITY_NAME#{n}" }

    trait :invalid do
      sequence(:name) { nil }
    end
  end
end
