FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:password) {|n| "#{n}_#{Faker::Internet.password(min_length: 10, max_length: 20)}" }
    sequence(:email) {|n| "#{n}_#{Faker::Internet.email}" }
  end
end
