FactoryBot.define do
  factory :test_oil, :class => "Oil" do
    name { "test_oil" }
  end

  factory :oil do
    sequence(:name) { |n| "OIL_NAME#{n}" }
  end
end
