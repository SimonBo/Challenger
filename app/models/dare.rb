class Dare < ActiveRecord::Base

  belongs_to :challenge
  belongs_to :acceptor, class_name: "User"
  belongs_to :challenger, class_name: "User"

  def user_you_challenged
    
  end
end
