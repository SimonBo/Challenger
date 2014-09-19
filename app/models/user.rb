class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :dares, foreign_key: :challenger_id
  has_many :accepted_dares, class_name: "Dare", foreign_key: :acceptor_id
  has_many :challenges, through: :dares

 
end
