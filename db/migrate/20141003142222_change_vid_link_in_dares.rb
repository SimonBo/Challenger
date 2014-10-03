class ChangeVidLinkInDares < ActiveRecord::Migration
  def change
    add_column :dares, :utube_link, :string, array: true
  end
end
