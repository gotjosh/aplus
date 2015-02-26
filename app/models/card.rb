class Card
  include Mongoid::Document
  field :question, type: String
  field :answer, type: String
  field :box, type: Integer
  belongs_to :topic

  validates :question, presence: true, length: { minimum: 2 }
  validates :answer, presence: true
end