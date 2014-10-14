FactoryGirl.define do
  factory :challenge do
    name { Faker::Lorem.sentence(3) }
    description { Faker::Lorem.sentence(6)}
  end
end