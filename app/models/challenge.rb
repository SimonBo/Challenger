class Challenge < ActiveRecord::Base
  # belongs_to :user
  # has_and_belongs_to_many :challenged_users, :class_name => "User"

  has_many :dares
  has_many :users, through: :dares

  validates :name, presence: true, uniqueness: true, length: { in: 2..50 }
  validates :description, presence: true, length: { in: 2..500 }
end
