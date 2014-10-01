class AddVidToDares < ActiveRecord::Migration
  def change
    add_column :dares, :vid_link, :string
  end
end
