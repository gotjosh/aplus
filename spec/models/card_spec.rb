require 'spec_helper'
require 'rails_helper'

describe Card do
  it "Takes a correctly answer card to the next level" do
    card = create(:card)
    Card.correct card
    card.reload
    expect(card.level).to eq(2)
    expect(card.card_statistic.times_correct).to eq(1)
  end

  it "Decreases the level of an incorrectly answerd card" do
    card = create(:card)
    Card.correct card  #because of this card_statistic.times_correct should be 1
    card.reload
    Card.incorrect card
    card.reload
    expect(card.level).to eq(1)
    expect(card.card_statistic.times_incorrect).to eq(1)
    expect(card.card_statistic.times_correct).to eq(1)
  end

  it "updates review_date"
  it "puts the given card in level 1" do
    card = create(:card)
    Card.correct card
    card.reload
    Card.correct card
    card.reload
    expect(card.level).to eq(3)
    Card.reset card
    card.reload
    expect(card.level).to eq(1)
  end
end
