# A subject is used to classify topics and organize them.
# It has a unique code, a name, a hex color. All these attributes must be present.
# A subject can be set as archived. An archived subject's topics won't
# be listed for showing or reviewing.
class Subject
  include Mongoid::Document
  field :code, type: String
  field :name, type: String
  field :color, type: String
  field :archived, type: Boolean, default: false
  
  has_many :topics
  belongs_to :user

  validates :code, length: { maximum: 7 }
  validates :name, :code, :color, presence: true
  validates :color, format: { with: /\A#([A-Fa-f0-9]{3}|[A-Fa-f0-9]{6})\z/, message: "only hex numbers" }
  validates_associated :topics

  scope :not_archived, -> { where(archived: false) }

  # Finds all the topics that belong to a user based on the username
  def self.from_user(username)
    user = User.find_by(username: username)
    user ? Subject.where(user_id: user._id) : nil
  end

  # Archives a subject and all its topics.
  def archive
    self.update(archived: true)
    self.topics.each do |topic|
      topic.update(archived: true)
    end
  end

  # Unarchives a subject and all its topics.
  def unarchive
    self.update(archived: false)
    self.topics.each do |topic|
      topic.update(archived: false)
    end
  end

  # Destroys all topics inside the subject
  def destroy_topics
    self.topics.each do |t|
      t.destroy
    end
  end

  # Shares the subject that belongs to another user, with the current user
  # It creates a new copy of the subject that belongs to the current user
  def share(username)
    user = User.find_by(username: username)

    # makes a copy of the subject for the current user
    new_subject = user.subjects.create(
      code: self.code,
      name: self.name,
      color: self.color,
      archived: false)

    # copies all the topics in the subject to the new subject
    self.topics.each do |topic|
      topic.share(username, new_subject)
    end
  end
end
