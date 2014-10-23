class Dare < ActiveRecord::Base

  belongs_to :challenge, counter_cache: true
  belongs_to :acceptor, class_name: "User"
  belongs_to :challenger, class_name: "User"

  has_many :votes

  before_save :change_status
  before_save :create_start_date
  before_save :set_proof_array

  # validate :cannot_challenge_if_acceptor_already_accepted

  def cannot_challenge_if_acceptor_already_accepted
    if self.acceptor.my_accepted_challenges.where("challenge_id = ?", self.challenge_id).any?
      errors.add(:acceptor_id, 'That user already accepted that challenge!')
    end
  end

  def is_self_selected?
    self.acceptor_id == self.challenger_id
  end
  def self.newest_voting
    where(status: 'Voting').order("voting_start_date desc")
  end
  
  def resolved?
    self.status.include?("Success") || self.status.include?("Failed")
  end

  def set_proof_array
    if self.utube_link.nil?
      self.utube_link = []
      save!
    end
  end

  def create_start_date
    if status == 'Accepted' && start_date.blank?
      self.start_date = DateTime.now
    end
  end

  def unaccepted_this_dare?
    if self.acceptor.accepted_dares && self.acceptor.accepted_dares.map{|e| e.challenge_id}.include?(self.challenge_id)
      errors.add :base, 'Already accepted'
      false
    end
  end

  def finishing_in
    (((self.start_date.midnight + 7.days) - Time.now)/86400).floor
  end

  def change_status
    if status.blank?
      if self.acceptor_id == self.challenger_id
        self.status = "Accepted"
      else
        self.status = "Pending"
      end
    end
  end



  def rejected?
    self.status.include? "Rejected"
  end

  def times_up?
    self.start_date.midnight <= 7.days.ago if self.start_date
  end

  def still_have_time?
    self.start_date.midnight > 7.days.ago if self.start_date
  end

  def unresolved?
    self.status.include?("Pending") || self.status.include?("Accepted")
  end

  def no_proof_fail?
    if self.utube_link.blank? && self.times_up? && self.unresolved?
      self.status = 'Failed'
      save!
    end
  end

  def proof_not_validated?
    self.proof_status != "Proof Accepted" && self.proof_status != "Proof Rejected"
  end

  def time_for_proof_validation_ended?
    self.start_date.midnight <= 12.days.ago 
  end

  def success_unvalidated?
    if self.proof? && self.time_for_proof_validation_ended? && self.proof_not_validated?
      self.status = 'Success'
      save!
    end
  end




  def votes_for
    self.votes.where("vote_for = ?", true).count
  end

  def votes_against
    self.votes.where("vote_for = ?", false).count
  end 
  
  def won_voting?
    self.votes_for >= self.votes_against
  end

  def voting_end_date
    self.voting_start_date.midnight + 5.days if self.voting_start_date
  end

  def voting_finished?
    unless self.after_voting?
      if self.voting_end_date <= DateTime.now
        if self.won_voting?
          self.status = 'Success'
          self.voting_status = 'Success'
        else
          self.status = 'Failed'
          self.voting_status = 'Failed'
        end
        save!
        UserMailer.challenger_voting_ended(self.challenger, self.acceptor, self).deliver
        UserMailer.acceptor_voting_ended(self.challenger, self.acceptor, self).deliver
      else
        false
      end
    end

  end

  def after_voting?
    self.voting_status == 'Success' || self.voting_status == 'Failed'
  end

  def voting_in_progress?
    self.status == 'Voting'
  end


  def proof?
    self.utube_link?
  end

  def up_for_voting?
    if self.times_up? && self.unresolved? && self.proof? && self.status != 'Voting'
      self.voting_start_date = DateTime.now
      self.status = 'Voting'
      save!
      UserMailer.voting_started(self.challenger, self.acceptor, self).deliver
    end
  end

end
