FactoryBot.define do
  factory :test_comment, :class => "Comment" do
    content           { "test_comment" }
    construction_id   { "1" }
    user_id           { "1" }
  end

  factory :comment do
    sequence(:id) { rand(10000..99999) }
    sequence(:content) { |n| "TEST_COMMENT#{n}" }
    sequence(:construction_id) { "1" }
    sequence(:user_id) { "1" }

    trait :invalid do
      sequence(:content) { nil }
    end
  end
end
