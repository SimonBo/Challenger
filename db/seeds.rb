
10.times do |i|
  User.create(username: "user#{i}", email: "user#{i}@email.com", password: 'useruser', password_confirmation: 'useruser')
end

challenge_name = ['Ice Bucket', 'Eat a dog', 'Steal somebody\'s wallet', 'Tell your boss he is an asshole', 'Stand on broken glass for 30 seconds']
description = "Integer posuere erat a ante venenatis dapibus posuere velit aliquet. Sed posuere consectetur est at lobortis."

5.times do |i|
  Challenge.create(name: challenge_name[i], description: description)
end


Dare.create(acceptor_id: 1, challenge_id: 1, challenger_id: 2)
Dare.create(acceptor_id: 1, challenge_id: 3, challenger_id: 5)
Dare.create(acceptor_id: 3, challenge_id: 1, challenger_id: 1, utube_link: ["-huwiIHUDSc"])
Dare.create(acceptor_id: 5, challenge_id: 2, challenger_id: 1, utube_link: ["56R3hU-fWZY"])
Dare.create(acceptor_id: 6, challenge_id: 4, challenger_id: 3, status: 'Voting', voting_start_date: DateTime.now, utube_link: ["dl7CLaZFG1c"])
Dare.create(acceptor_id: 1, challenge_id: 5, challenger_id: 6, status: 'Success', voting_start_date: 7.days.ago, utube_link: ["dl7CLaZFG1c"], voting_status: 'Success')

