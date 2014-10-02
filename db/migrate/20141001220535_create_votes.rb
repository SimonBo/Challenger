class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.boolean :for
      t.references :user, index: true
      t.references :dare, index: true

      t.timestamps
    end
  end
end
