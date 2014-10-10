class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :dare

  validate :validate_vote

    def validate_vote
      if Vote.where("dare_id = ? AND user_id = ?", self.dare_id, self.user_id).any?
        # flash[:alert] = 'You already voted!'
        errors.add :base, 'You already voted!'
      end
    end

end
