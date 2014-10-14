FactoryGirl.define do
  factory :vote do
    vote_for true
    user_id {Faker::Number.digit}
    dare_id {Faker::Number.digit}
  end
end