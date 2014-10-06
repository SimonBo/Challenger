namespace :dares do
  desc "Fail dares that have no proof and 7 days passed since start_date"
  task fail_no_proof: :environment do

    Dare.all.each do |dare|
      dare.no_proof_fail?
      dare.success_unvalidated?
      dare.up_for_voting? 
      dare.voting_finished? 
    end
  end
end
