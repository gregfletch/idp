# frozen_string_literal: true

require 'rails_helper'

describe Rack::Attack, type: :request do
  include Rack::Test::Methods

  let(:user) { create(:user, :confirmed_user, password: 'Password1') }
  let(:params) do
    {
      user: {
        email: user.email,
        password: user.password
      }
    }
  end
  let(:sign_in_throttle_limit) { 20 }

  before do
    described_class.cache.store = ActiveSupport::Cache::MemoryStore.new
    Rails.cache.clear
    described_class.enabled = true
    described_class.reset!
  end

  # rubocop:disable Rails/HttpPositionalArguments
  it 'returns ok on calls to /users/sign_in within the throttle limit' do
    sign_in_throttle_limit.times do
      post '/users/sign_in', params, 'REMOTE_ADDR' => '1.2.3.4'
      expect(last_response.status).to eq(200)
    end
  end

  it 'returns too many calls on /users/sign_in after the throttle limit' do
    (sign_in_throttle_limit * 2).times do |i|
      post '/users/sign_in', params, 'REMOTE_ADDR' => '1.2.3.4'
      expect(last_response.status).to eq(429) unless i < sign_in_throttle_limit
    end
  end

  it 'does not throttle calls to /users/sign_in from localhost in development environment' do
    allow(Rails.env).to receive(:development?).and_return(true)

    (sign_in_throttle_limit * 2).times do
      post '/users/sign_in', params, 'REMOTE_ADDR' => '127.0.0.1'
      expect(last_response.status).to eq(200)
    end
  end

  it 'does throttle calls to /users/sign_in from localhost in non-development environment' do
    (sign_in_throttle_limit * 2).times do |i|
      post '/users/sign_in', params, 'REMOTE_ADDR' => '127.0.0.1'
      expect(last_response.status).to eq(429) unless i < sign_in_throttle_limit
    end
  end

  it 'does not throttle calls to endpoints other than /users/sign_in' do
    (sign_in_throttle_limit * 2).times do
      delete '/users/sign_out', {}, 'REMOTE_ADDR' => '1.2.3.4'

      # Expect a 401 here, as we are not passing an auth token for the user to sign out with
      expect(last_response.status).to eq(401)
    end
  end
  # rubocop:enable Rails/HttpPositionalArguments
end
