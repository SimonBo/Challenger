class AddCounterCacheToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :dares_count, :integer, default: 0

    Challenge.reset_column_information
    Challenge.find_each do |u|
      Challenge.reset_counters u.id, :dares
    end
  end


end
