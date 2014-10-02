class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :dares, foreign_key: :challenger_id
  has_many :accepted_dares, class_name: "Dare", foreign_key: :acceptor_id
  has_many :challenges, through: :dares
  has_many :votes


  def my_pending_challenges
    self.accepted_dares.where("acceptor_id = ? AND status = ?", self.id, 'Pending')
  end

  def my_challenged_users
    self.dares.where.not(acceptor_id: self.id)
  end

  def challenges_ending_tomorrow
    self.accepted_dares.where(["created_at >= ?", 6.days.ago])
  end

  def my_accepted_challenges
    self.accepted_dares.where("status = ?", 'Accepted')
  end

  def completed_challanges
    self.accepted_dares.where("status = ?", 'Completed')
  end

  def failed_challenges
    self.accepted_dares.where("status = ?", 'Failed')
  end

  def rejected_challenges
    self.accepted_dares.where("status = ?", 'Rejected')
  end
end
