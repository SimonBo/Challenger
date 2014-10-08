class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :dares, foreign_key: :challenger_id
  has_many :accepted_dares, class_name: "Dare", foreign_key: :acceptor_id
  has_many :challenges, through: :dares
  has_many :votes



  def is_acceptor?(dare)
    self.accepted_dares.where('id = ?', dare.id).present?
  end

  def is_challenger?(dare)
    self.dares.where('id = ?', dare.id).present?
  end

  def my_pending_challenges
    self.accepted_dares.where("status = ?", 'Pending')
  end

  def my_challenged_users
    self.dares.where.not(acceptor_id: self.id)
  end

  def challenges_ending_tomorrow
    self.accepted_dares.where(["start_date <= ? and status = ?", 6.days.ago, "Accepted"])
  end

  def already_accepted_this_challenge?(challenge)
    self.accepted_dares.where("challenge_id = ?", challenge.id).exists?
  end

  def my_accepted_challenges
    self.accepted_dares.where("status = ?", 'Accepted')
  end

  def completed_challanges
    self.accepted_dares.where("status = ? OR status = ?", "Success", "Voting-Success")
  end

  def failed_challenges
    self.accepted_dares.where("status = ?", 'Failed')
  end

  def rejected_challenges
    self.accepted_dares.where("status = ?", 'Rejected')
  end

  def user_voted?(dare)
    self.votes.where("dare_id = ?", dare.id).any?
  end
end
