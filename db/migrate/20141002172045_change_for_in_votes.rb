class ChangeForInVotes < ActiveRecord::Migration
  def change
    rename_column :votes, :for, :vote_for
  end
end
