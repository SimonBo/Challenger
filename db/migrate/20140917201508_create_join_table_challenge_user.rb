class CreateJoinTableChallengeUser < ActiveRecord::Migration
  def change
    create_join_table :challenges, :users do |t|
      # t.index [:challenge_id, :user_id]
      # t.index [:user_id, :challenge_id]
    end
  end
end
