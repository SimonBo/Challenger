
10.times do |i|
  User.create(username: Faker::Internet.user_name , email: Faker::Internet.email, password: 'useruser', password_confirmation: 'useruser')
end

User.create(username: "Bymon Szorucki", email: "bymon.szorucki@gmail.com", password: 'useruser', password_confirmation: 'useruser')

challenge_name = ['Ice Bucket', 'Eat a dog', 'Steal somebody\'s wallet', 'Tell your boss he is an asshole', 'Stand on broken glass for 30 seconds']

5.times do |i|
  Challenge.create(name: challenge_name[i], description: Faker::Lorem.sentence)
end


Dare.create(acceptor_id: 1, challenge_id: 1, challenger_id: 2)
Dare.create(acceptor_id: 1, challenge_id: 3, challenger_id: 5)
Dare.create(acceptor_id: 3, challenge_id: 1, challenger_id: 1, utube_link: ["-huwiIHUDSc"])
Dare.create(acceptor_id: 5, challenge_id: 2, challenger_id: 1, utube_link: ["56R3hU-fWZY"])
Dare.create(acceptor_id: 6, challenge_id: 4, challenger_id: 3, status: 'Voting', voting_start_date: DateTime.now, utube_link: ["dl7CLaZFG1c"])
Dare.create(acceptor_id: 1, challenge_id: 5, challenger_id: 6, status: 'Success', voting_start_date: 7.days.ago, utube_link: ["dl7CLaZFG1c"], voting_status: 'Success')


Challenge.create(name: "Join the Zombie Walk!", description: "Join the 2015 Toronto (or any other) Zombie walk.")