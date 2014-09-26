class Dare < ActiveRecord::Base

  belongs_to :challenge
  belongs_to :acceptor, class_name: "User"
  belongs_to :challenger, class_name: "User"

  before_save :change_status

  def finishing_in
    (((self.created_at + 7.days) - Time.now)/86400).floor
  end

  def change_status
    if status.blank?
      if self.acceptor == self.challenger
        self.status = "Accepted"
      else
        self.status = "Pending"
      end
    end
  end

end
