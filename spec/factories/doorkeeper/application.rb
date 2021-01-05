# frozen_string_literal: true

FactoryBot.define do
  factory :doorkeeper_application, class: 'Doorkeeper::Application' do
    uid { SecureRandom.base58(32) }
    secret { SecureRandom.base58(32) }
    name { Faker::Company.name }
    redirect_uri { 'urn:ietf:wg:oauth:2.0:oob' }
    scopes { 'api:graphql' }
    confidential { false }
  end
end
