class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:facebook]

  has_many :dares, foreign_key: :challenger_id
  has_many :accepted_dares, class_name: "Dare", foreign_key: :acceptor_id
  has_many :challenges, through: :dares
  has_many :votes

  validates :username, presence: true, uniqueness: true, length: { in: 2..50 }


  def facebook
    @facebook ||= Koala::Facebook::API.new(oauth_token)
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.username = auth.info.name   # assuming the user model has a name
      # user.image = auth.info.image # assuming the user model has an image
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      binding.pry
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def password_required?
    super && self.provider.blank?
  end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end

  def has_no_password?
    self.encrypted_password.blank?
  end

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

  def self.sorted_by_accepted_dares
    self.joins(:accepted_dares).select("count(dares.*) as dare_count, users.*").where("dares.status = ?","Success").group("users.id").order("dare_count DESC")
  end
end
