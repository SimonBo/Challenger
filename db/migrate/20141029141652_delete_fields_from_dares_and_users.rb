class DeleteFieldsFromDaresAndUsers < ActiveRecord::Migration
  def change
    remove_column :dares, :amount, :integer
    remove_column :dares, :with_bet, :boolean
    remove_column :users, :stripe_customer_token, :string
  end
end
