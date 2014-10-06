namespace :dares do
  desc "Filter all dares"
  task fail_no_proof: :environment do

    Dare.all.each do |dare|
      dare.no_proof_fail?
      dare.success_unvalidated?
      dare.up_for_voting? 
      dare.voting_finished? 
    end
  end
end
