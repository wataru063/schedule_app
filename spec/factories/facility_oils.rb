FactoryBot.define do
  factory :test_facility_oil, :class => "FacilityOil" do
    facility_id { "1" }
    oil_id      { "1" }
  end

  factory :facility_oil do
    sequence(:facility_id) { |n| "#{n}" }
    sequence(:oil_id)      { |n| "#{n + 1}" }
  end
end
