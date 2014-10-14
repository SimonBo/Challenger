FactoryGirl.define do
  factory :dare do
    challenge_id {Faker::Number.digit}
    challenger_id {Faker::Number.digit}
    acceptor_id { Faker::Number.digit }
  end
end