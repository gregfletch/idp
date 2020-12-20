# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::ConfirmationsController do
  before do
    # rubocop:disable RSpec/InstanceVariable
    @request.env['devise.mapping'] = Devise.mappings[:user]
    # rubocop:enable RSpec/InstanceVariable
  end

  #
  # #GET /users/confirmation
  #
  describe 'get #show' do
    let(:user) { create(:user, :unconfirmed_user) }
    let(:params) { { confirmation_token: user.confirmation_token } }

    it 'sets the confirmed_at timestamp on success' do
      get :show, params: params
      expect(User.last.confirmed_at).not_to be_nil
    end

    it 'returns ok on success' do
      get :show, params: params
      expect(response).to have_http_status(:ok)
    end

    it 'returns JSON object containing user attributes on success' do
      get :show, params: params
      result_user = JSON.parse(response.body, symbolize_names: true)[:result][:user]
      expect(result_user).not_to be_nil
    end

    it 'returns bad_request if missing required parameters' do
      get :show
      expect(response).to have_http_status(:bad_request)
    end

    it 'returns bad_request if parameters is empty hash' do
      get :show, params: {}
      expect(response).to have_http_status(:bad_request)
    end

    it 'returns bad_request if confirmation_token parameter is blank' do
      get :show, params: { confirmation_token: '' }
      expect(response).to have_http_status(:bad_request)
    end

    it 'returns bad_request if provided confirmation_token is unknown' do
      get :show, params: { confirmation_token: SecureRandom.base58(18) }
      expect(response).to have_http_status(:bad_request)
    end
  end

  #
  # #GET /users/confirmation/new
  #
  describe 'get #new' do
    it 'returns not_found' do
      get :new
      expect(response).to have_http_status(:not_found)
    end
  end

  #
  # #POST /users/confirmation
  #
  describe 'post #create' do
    it 'returns not_found' do
      post :create
      expect(response).to have_http_status(:not_found)
    end
  end
end
