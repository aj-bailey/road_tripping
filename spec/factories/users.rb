FactoryBot.define do
  factory :user do
    email { Faker::Internet.safe_email }
    password_digest { Faker::Internet.password }
  end
end
