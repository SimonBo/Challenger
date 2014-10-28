namespace :dares do
  desc "Filter all dares"
  task process: :environment do

    Dare.find_each do |dare|
      unless dare.status == 'Failed' || dare.status == 'Rejected'
        dare.process
      end
    end
  end
end
