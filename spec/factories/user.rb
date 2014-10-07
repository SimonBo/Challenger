FactoryGirl.define do
  factory :user do
    username "JoeBlow"
    sequence(:email) { |n| "user#{n}@email.com"} 
    password 'useruser'
    password_confirmation 'useruser'
  end
end