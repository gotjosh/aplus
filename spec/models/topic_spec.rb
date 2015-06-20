require 'rails_helper'

describe Topic do
  it "Can reset all cards in a topic" do
    topic = create(:topic_with_cards)
    Topic.reset_cards topic
    topic.reload
    topic.cards.each do |card|
      expect(card.level).to eq(1)
    end
  end
end
