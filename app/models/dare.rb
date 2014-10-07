class Dare < ActiveRecord::Base

  belongs_to :challenge
  belongs_to :acceptor, class_name: "User"
  belongs_to :challenger, class_name: "User"

  has_many :votes

  # validates :with_bet, acceptance: true
  validate :unaccepted_this_dare?
  before_save :change_status
  before_save :create_start_date
  # before_save :queue_delayed_job

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

  def unresolved?
    # state = ['Pending', 'Accepted']
    # state.any? {|str| self.status.include? str}

    self.status.include?("Pending") || self.status.include?("Accepted")
  end

  def no_proof_fail?
    if self.utube_link.blank? && self.times_up? && self.unresolved?
      self.status = 'Failed'
      save!
    end
  end

  def proof_not_validated?
    self.status != "Proof Accepted" && self.status != "Proof Rejected"
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
    self.voting_start_date.midnight + 5.days
  end

  def voting_finished?
    unless self.after_voting?
      if self.voting_end_date <= DateTime.now
        if self.won_voting?
          self.status = 'Voting-Success'
        else
          self.status = 'Voting-Failed'
        end
        save!
      end
    end

  end

  def after_voting?
    self.status == 'Voting-Success' || self.status == 'Voting-Failed'
  end

  def voting_in_progress?
    self.status == 'Voting'
  end


  def proof?
    self.utube_link?
  end

  def up_for_voting?
    if self.times_up? && self.unresolved? && self.proof?
      self.voting_start_date = DateTime.now
      save!
    end
  end



  def prepare_with_payment(stripe_card_token, user)

    if valid?
      customer = Stripe::Charge.create(description: user.email, amount: amount*100, card: stripe_card_token, currency: 'usd')
      user.stripe_customer_token = customer.id
      user.save

    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end
end
