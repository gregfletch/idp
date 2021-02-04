# frozen_string_literal: true

FactoryBot.define do
  factory :login_activity do
    scope { 'user' }
    strategy { 'database_authenticatable' }
    success { true }
    user { create(:user) }
    ip { Faker::Internet.ip_v4_address }
  end
end
