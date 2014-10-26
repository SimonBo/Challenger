class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :recipient_email
      t.references :user, index: true
      t.references :dare, index: true
      t.string :token
      t.string :status

      t.timestamps
    end
  end
end
