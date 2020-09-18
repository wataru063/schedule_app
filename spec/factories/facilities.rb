FactoryBot.define do
  factory :test_facility, :class => "Facility" do
    id   { 999 }
    name { "test_facility" }
  end

  factory :facility do
    sequence(:id) { rand(10000..99999) }
    sequence(:name) { |n| "FACILITY_NAME#{n}" }
  end
end
