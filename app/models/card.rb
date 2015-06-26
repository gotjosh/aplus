# A card has a front side, a back side, and the number of the box it's in. 
# The front side, and back side are obligatory.
# The box number must either 1, 2, or 3.
# All cards belong to a topic.
class Card
  include Mongoid::Document
  field :front, type: String
  field :back, type: String
  field :level, type: Integer, default: 1
  field :review_date, type: DateTime, default: DateTime.now

  embeds_one :card_statistic
  belongs_to :topic
  belongs_to :user

  validates :front, :back, :level, presence: true
  validates :topic, presence: { is: true, message: "must belong to a topic." }
  validates :user, presence: { is: true, message: "must belong to a user." }
  validates :level, numericality: { only_integer: true, greater_than: 0 }

  # Moves a card that was answered correctly to the next level, and updates
  # the time it takes to answer the card.
  def correct(total_time)
  	self.inc(level: 1)
    self.card_statistic.inc(time_answering: total_time)
    self.card_statistic.inc(times_correct: 1)
  end

  # Moves a card that was answered incorrectly to the previous level, and updates
  # the time it takes to answer the card.
  def incorrect(total_time)
    if self.level > 1
      self.inc(level: -1)
      self.card_statistic.inc(time_answering: total_time)
      self.card_statistic.inc(times_incorrect: 1)
    end
  end

  # Update review date based on level, and desired recall percentage of the topic.
  # Recall function: R = e^(-t/S)
  # where t is the number of days that can pass without studying the card before
  # it recall percentage drops below the topic's.
  # S = 2^n, where n is the card level
  def update_review_date
    r = self.topic.recall_percentage
    n = self.level

    # Level of understanding
    s = 2**n

    # t = -ln(R)*S
    t = -s*Math.log(r)

    # Update date
    self.review_date += t
    self.save
  end

  # Moves a card back to box 1.
  def reset
  	self.update(level: 1)
  end
end
