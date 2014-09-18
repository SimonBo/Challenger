class CreateDares < ActiveRecord::Migration
  def change
    create_table :dares do |t|
      t.integer :acceptor_id
      t.integer :challenger_id
      t.integer :challenge_id
      t.string :status
      t.timestamps
    end
  end
end
