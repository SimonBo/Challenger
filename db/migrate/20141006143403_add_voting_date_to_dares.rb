class AddVotingDateToDares < ActiveRecord::Migration
  def change
    add_column :dares, :voting_start_date, :datetime
  end
end
