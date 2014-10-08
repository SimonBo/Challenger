class AddVotingStatusToDares < ActiveRecord::Migration
  def change
    add_column :dares, :voting_status, :string, default: 'None'
  end
end
