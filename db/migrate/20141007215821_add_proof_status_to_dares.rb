class AddProofStatusToDares < ActiveRecord::Migration
  def change
    add_column :dares, :proof_status, :string, default: 'Unaccepted'
  end
end
