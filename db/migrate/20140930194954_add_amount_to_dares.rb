class AddAmountToDares < ActiveRecord::Migration
  def change
    add_column :dares, :amount, :integer
  end
end
