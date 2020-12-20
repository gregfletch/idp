# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    email { Faker::Internet.email }
    username { Faker::Internet.username }
    password { Faker::Internet.password }
  end

  trait :unconfirmed_user do
    confirmation_token { SecureRandom.base58(18) }
  end

  trait :confirmed_user do
    confirmation_token { SecureRandom.base58(18) }
    confirmed_at { Time.now.utc.iso8601 }
  end
end
