# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

10.times do |i|
  User.create(username: "user#{i}", email: "user#{i}@email.com", password: 'useruser', password_confirmation: 'useruser')
end

challenge_name = ['Ice Bucket', 'Eat a dog', 'Steal somebody\'s wallet', 'Tell your boss you want to rape his wife/husband', 'Try to mainain erection for 10 hours']
description = "Integer posuere erat a ante venenatis dapibus posuere velit aliquet. Sed posuere consectetur est at lobortis."

5.times do |i|
  Challenge.create(name: challenge_name[i], description: description)
end