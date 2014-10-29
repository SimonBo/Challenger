class AddCanpostToUsers < ActiveRecord::Migration
  def change
    add_column :users, :can_post, :boolean, default: false
  end
end
