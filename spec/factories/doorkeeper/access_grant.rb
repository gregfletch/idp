# frozen_string_literal: true

FactoryBot.define do
  factory :doorkeeper_access_grant, class: 'Doorkeeper::AccessGrant' do
    application { create(:doorkeeper_application) }
    resource_owner_id { create(:user, :confirmed_user).id }
    expires_in { 10.minutes }
    redirect_uri { 'urn:ietf:wg:oauth:2.0:oob' }
    scopes { 'api:graphql' }
    code_challenge { SecureRandom.base58(128) }
    code_challenge_method { 'plain' }
    token { 'code' }
  end
end
