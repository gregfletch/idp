# frozen_string_literal: true

require 'rails_helper'

describe Doorkeeper::TokensController do
  #
  # #POST /oauth/token
  #
  describe 'post #oauth_token' do
    let(:password) { 'Password1' }
    let(:user) { create(:user, :confirmed_user, password: password) }
    let(:unconfirmed_user) { create(:user, :unconfirmed_user, password: password) }
    let(:application) { create(:doorkeeper_application) }
    let(:params) do
      {
        grant_type: 'password',
        email: user.email,
        password: password,
        client_id: application.uid
      }
    end

    it 'returns ok on success' do
      post :create, params: params
      expect(response).to have_http_status(:ok)
    end

    it 'returns an access token on success' do
      post :create, params: params
      expect(JSON.parse(response.body, symbolize_names: true)[:access_token]).not_to be_nil
    end

    it 'returns an access token of type Bearer on success' do
      post :create, params: params
      expect(JSON.parse(response.body, symbolize_names: true)[:token_type]).to eq('Bearer')
    end

    it 'includes a refresh token in the response on success' do
      post :create, params: params
      expect(JSON.parse(response.body, symbolize_names: true)[:refresh_token]).not_to be_nil
    end

    it 'returns bad_request if user is unconfirmed' do
      unconfirmed_user_params = params.dup
      unconfirmed_user_params[:email] = unconfirmed_user.email
      post :create, params: unconfirmed_user_params
      expect(response).to have_http_status(:bad_request)
    end

    it 'returns bad_request if user is unknown' do
      unknown_user_params = params.dup
      unknown_user_params[:email] = 'unknown.user@mail.com'
      post :create, params: unknown_user_params
      expect(response).to have_http_status(:bad_request)
    end

    it 'returns bad_request if password is incorrect' do
      incorrect_password_params = params.dup
      incorrect_password_params[:password] = 'BadPASSWORD'
      post :create, params: incorrect_password_params
      expect(response).to have_http_status(:bad_request)
    end

    it 'returns unauthorized if client_id is unknown' do
      unknown_client_id_params = params.dup
      unknown_client_id_params[:client_id] = 'unknown_client_id'
      post :create, params: unknown_client_id_params
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns bad_request if grant_type is not supported for application' do
      unsupported_params = params.dup
      unsupported_params[:grant_type] = 'implicit'
      post :create, params: unsupported_params
      expect(response).to have_http_status(:bad_request)
    end

    it 'returns bad_request if grant_type is unknown' do
      grant_type_unknown_params = params.dup
      grant_type_unknown_params[:grant_type] = 'unknown'
      post :create, params: grant_type_unknown_params
      expect(response).to have_http_status(:bad_request)
    end
  end
end
