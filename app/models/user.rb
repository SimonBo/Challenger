class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :owned_challenges, class_name: "Challenge"
  has_many :pending_challenges, class_name: "Challenge"

  has_and_belongs_to_many :accepted_challenges, :class_name => "Challenge"

end
