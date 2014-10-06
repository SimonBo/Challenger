namespace :testing do
  desc "Change accepted to pending"
  task change_status: :environment do
    dares = Dare.where(status: 'Accepted')

    dares.each do |dare|
      dare.status = 'Changed!'
      dare.save
    end
  end

  desc "Check methods from model"
  task check_meth: :environment do 
    dares = Dare.where(status: "Changed!")
    dares.each {|d| d.show_accepted}
  end

end
