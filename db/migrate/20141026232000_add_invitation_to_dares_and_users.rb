class AddInvitationToDaresAndUsers < ActiveRecord::Migration
  def change
    add_column :dares, :invitation_id, :integer
    add_column :users, :invitation_id, :integer
  end
end
