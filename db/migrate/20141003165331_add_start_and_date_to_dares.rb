class AddStartAndDateToDares < ActiveRecord::Migration
  def change
    add_column :dares, :start_date, :datetime
    add_column :dares, :end_date, :datetime
  end
end
