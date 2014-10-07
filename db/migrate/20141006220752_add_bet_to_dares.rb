class AddBetToDares < ActiveRecord::Migration
  def change
    add_column :dares, :with_bet, :boolean, default: false
  end
end
