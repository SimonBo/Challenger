class DeleteUselessTables < ActiveRecord::Migration
  def change
    drop_table :challenges_users
    drop_table :mailboxer_conversation_opt_outs
    drop_table :mailboxer_receipts
    drop_table :mailboxer_notifications
    drop_table :mailboxer_conversations
  end
end


