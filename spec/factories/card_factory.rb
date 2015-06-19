FactoryGirl.define do
  factory :card do
    front "2+2"
    back '4'
    review_date DateTime.now
    card_statistic { FactoryGirl.build(:card_statistic) }
    user
    topic
  end

  factory :card_statistic do
  end
end

