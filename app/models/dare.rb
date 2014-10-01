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

  def save_with_payment(stripe_card_token, user)

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
