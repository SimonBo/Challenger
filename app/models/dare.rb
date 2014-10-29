class Dare < ActiveRecord::Base

  belongs_to :challenge, counter_cache: true
  belongs_to :acceptor, class_name: "User"
  belongs_to :challenger, class_name: "User"
  belongs_to :invitation

  has_many :votes


  before_save :change_status
  before_save :create_start_date
  before_save :set_proof_array

  # validate :cannot_challenge_if_acceptor_already_accepted

  def process
    self.no_proof_fail?
    self.success_unvalidated?
    self.up_for_voting? 
    self.voting_finished? 
    self.dare_expires_tommorow?
  end

  def post_on_fb(event)
    acceptor = self.acceptor
    challenger = self.challenger
    challenge = self.challenge
    url = Rails.application.routes.url_helpers.challenge_dare_url(self.challenge_id, self.id, :host => "simon-challenger.herokuapp.com")
    if acceptor.can_post_on_fb?
      case event
      when "accepted_challenge"
        attachment = {"name"=>"#{challenge.name}", "link"=> url, "description"=>"Follow #{acceptor.username}'s progress here!"}
        acceptor.facebook.put_wall_post("I accepted the #{challenge.name} challenge from the Challenger!", attachment) 
      when "uploaded_proof"
        attachment = {"name"=>"#{challenge.name}", "link"=> url, "description"=>"Check it out here!"}
        acceptor.facebook.put_wall_post("I uploaded proof of completion of the #{challenge.name} challenge!", attachment) 
      when "Voting started"
        attachment = {"name"=>"#{challenge.name}", "link"=> url, "description"=>"Check it out here!"}
        acceptor.facebook.put_wall_post("My #{challenge.name} challenge was put to the vote!", attachment) 
      when "Voting finished"
        attachment = {"name"=>"#{challenge.name}", "link"=> url, "description"=>"See if I won here!"}
        acceptor.facebook.put_wall_post("My #{challenge.name} challenge's voting has finished!", attachment) 
      end
    end

    if  challenger.can_post_on_fb? && event == "accepted_challenge"
      attachment = {"name"=>"#{challenge.name}", "link"=> url, "description"=>"Follow #{challenger.username}'s challenge here!"}
      challenger.facebook.put_wall_post("I challenged #{acceptor.username} to the #{challenge.name} on Challenger!", attachment) 
    end
  end

  def dare_expires_tommorow?
    if self.start_date.midnight <= 6.days.ago 
      UserMailer.dare_expires_tommorrow(self).deliver
    end
  end

  def is_invitation?
    self.status = 'invitation-pending'
  end

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
    self.status == "Success" || self.status == "Failed"
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
    self.status == "Rejected"
  end

  def times_up?
    self.start_date.midnight <= 7.days.ago if self.start_date?
  end

  def still_have_time?
    self.start_date.midnight > 7.days.ago if self.start_date?
  end

  def unresolved?
    self.status == "Pending" || self.status == "Accepted"
  end

  def no_proof_fail?
    if self.utube_link.blank? && self.times_up? && self.unresolved?
      self.status = 'Failed'
      save!
      UserMailer.challenger_no_proof_fail(self.challenger, self.acceptor, self).deliver
      UserMailer.acceptor_no_proof_fail(self.challenger, self.acceptor, self).deliver
    end
  end

  def proof_not_validated?
    self.proof_status != "Proof Accepted" && self.proof_status != "Proof Rejected"
  end

  def time_for_proof_validation_ended?
    if self.start_date?
      self.start_date.midnight <= 9.days.ago 
    end
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
    self.voting_start_date.midnight + 5.days if self.voting_start_date?
  end

  def voting_finished?
    unless self.after_voting? || self.voting_start_date.nil?
      if self.voting_end_date <= DateTime.now
        if self.won_voting?
          self.status = 'Success'
          self.voting_status = 'Success'
        else
          self.status = 'Failed'
          self.voting_status = 'Failed'
        end
        save!
        self.post_on_fb("Voting finished")
        if self.is_self_selected?
          UserMailer.self_selected_voting_ended(self.challenger, self).deliver
        else
          UserMailer.challenger_voting_ended(self.challenger, self.acceptor, self).deliver
          UserMailer.acceptor_voting_ended(self.challenger, self.acceptor, self).deliver
        end
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
    self.utube_link? || self.pic_link?
  end

  def up_for_voting?
    if self.times_up? && self.unresolved? && self.proof? && self.status != 'Voting'
      self.voting_start_date = DateTime.now
      self.status = 'Voting'
      save!
      self.post_on_fb("Voting started")
      UserMailer.voting_started(self.challenger, self.acceptor, self).deliver
    end
  end

end
