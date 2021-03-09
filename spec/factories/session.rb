# frozen_string_literal: true

FactoryBot.define do
  factory :session do
    user { create(:user, :confirmed_user, :skip_validate) }
  end

  trait :consumed do
    consumed_at { Time.now.utc.iso8601 }
  end
end
