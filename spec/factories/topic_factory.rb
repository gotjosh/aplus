FactoryGirl.define do
  factory :topic do
    title "Planet Zero"
    reviewing true
    user

    factory :topic_with_cards do
      after(:create) do |topic|
        create(:card, topic: topic)
      end
    end
  end
end

