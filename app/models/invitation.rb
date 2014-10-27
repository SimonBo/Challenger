class Invitation < ActiveRecord::Base
  belongs_to :sender, :class_name => 'User'
  has_one :recipient, :class_name => 'User'
  has_one :dare

  validates_presence_of :recipient_email
  validate :recipient_is_not_registered

  before_create :generate_token

  attr_accessor :challenge_id

  def prepare_dare(challenge)
    new_dare = Dare.create!(challenge_id: challenge, challenger_id: self.user_id, status: "Invitation-pending")
    self.dare_id = new_dare.id
    save!
  end

  private

  def recipient_is_not_registered
    errors.add :recipient_email, 'is already registered' if User.where("email = ?", recipient_email).any?
  end

  def generate_token
    self.token = Digest::SHA1.hexdigest([Time.now, rand].join)
  end

end
