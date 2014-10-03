class Dare < ActiveRecord::Base

  belongs_to :challenge
  belongs_to :acceptor, class_name: "User"
  belongs_to :challenger, class_name: "User"

  has_many :votes

  before_save :change_status

  def finishing_in
    (((self.start_date + 7.days) - Time.now)/86400).floor
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

  def times_up?
    self.start_date <= 7.days.ago
  end

  def unresolved?
    # state = ['Pending', 'Accepted']
    # state.any? {|str| self.status.include? str}

    self.status.include?("Pending") || self.status.include?("Accepted")
  end

  def votes_for
    self.votes.where("vote_for = ?", true).count
  end

  def votes_against
    self.votes.where("vote_for = ?", false).count
  end 

  def voting_start_date
    self.votes.first.created_at
  end 

  def voting_end_date
    self.voting_start_date + 5.days
  end

  def voting_finished?
    self.voting_end_date <= DateTime.now
  end

  def voting_result
    self.vote_for >= self.votes_against
  end

  def proof?
    self.utube_link?
  end

  def up_for_voting?
    self.times_up? && self.unresolved? && self.proof?
  end

  # def calculate_votes
  #   self.votes
  # end

  # def resolve
  #   if self.times_up && self.unresolved
  #     if self.proof
  #       self.calculate_votes
  #     else
  #       self.status = 'Failed'
  #     end
  #   end
  # end

  def save_with_payment(stripe_card_token, user)

    if valid?
      customer = Stripe::Charge.create(description: user.email, amount: amount*100, card: stripe_card_token, currency: 'usd')
      user.stripe_customer_token = customer.id
      user.save
      save!
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end
end
