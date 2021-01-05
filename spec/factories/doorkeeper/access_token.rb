# frozen_string_literal: true

FactoryBot.define do
  factory :doorkeeper_access_token, class: 'Doorkeeper::AccessToken' do
    application { create(:doorkeeper_application) }
    expires_in { 2.hours }
    scopes { 'api:graphql' }
  end
end
