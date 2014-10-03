class DeleteVidLinkFromDares < ActiveRecord::Migration
  def change
    remove_column :dares, :vid_link
  end
end
