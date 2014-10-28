FactoryGirl.define do
  factory :dare do
    challenge_id {Faker::Number.digit}
    challenger_id {Faker::Number.digit}
    acceptor_id { Faker::Number.digit }
  end

  factory :accepted_dare do
    challenge_id {Faker::Number.digit}
    challenger_id {Faker::Number.digit}
    acceptor_id { Faker::Number.digit }
    start_date { DateTime.now}
  end
end