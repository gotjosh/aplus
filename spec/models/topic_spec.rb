require 'rails_helper'
require 'spec_helper'

describe Topic do
  it "Can reset all cards in a topic" do
    topic = create(:topic)
    Topic.reset_cards topic
    topic.reload
    p topic.cards
    topic.cards.each do |card|
      expect(card.level).to eq(1)
    end
  end
end
