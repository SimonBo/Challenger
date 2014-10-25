class AddPicLinkToDares < ActiveRecord::Migration
  def change
    add_column :dares, :pic_link, :string, array: true, default: []
  end
end
