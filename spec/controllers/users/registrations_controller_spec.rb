# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::RegistrationsController do
  before do
    # rubocop:disable RSpec/InstanceVariable
    @request.env['devise.mapping'] = Devise.mappings[:user]
    # rubocop:enable RSpec/InstanceVariable
  end

  #
  # #POST /users
  #
  describe 'post #create' do
    let(:user) { build(:user) }
    let(:params) do
      {
        user: {
          email: user.email,
          password: user.password,
          first_name: user.first_name,
          last_name: user.last_name
        }
      }
    end

    it 'increments user count on success' do
      expect { post :create, params: params }.to change(User, :count).by(1)
    end

    it 'creates new user on success with provided parameters' do
      post :create, params: params
      user = User.last
      expect(user.email).to eq(params[:user][:email])
    end

    it 'returns created on success' do
      post :create, params: params
      expect(response).to have_http_status(:created)
    end

    it 'returns JSON object containing provided user attributes on success' do
      post :create, params: params
      result_user = JSON.parse(response.body, symbolize_names: true)[:result][:user]
      expect(result_user.slice(:email, :first_name, :last_name)).to eq(params[:user].except(:password))
    end

    it 'returns bad_request if missing required parameters' do
      post :create
      expect(response).to have_http_status(:bad_request)
    end

    it 'returns bad_request if parameters is empty hash' do
      post :create, params: {}
      expect(response).to have_http_status(:bad_request)
    end

    it 'returns bad_request if user parameter is empty hash' do
      post :create, params: { user: {} }
      expect(response).to have_http_status(:bad_request)
    end

    it 'returns bad_request if email is missing' do
      post :create, params: { user: { password: user.password,
                                      first_name: user.first_name,
                                      last_name: user.last_name } }
      expect(response).to have_http_status(:bad_request)
    end

    it 'returns bad_request if password is missing' do
      post :create, params: { user: { email: user.email,
                                      first_name: user.first_name,
                                      last_name: user.last_name } }
      expect(response).to have_http_status(:bad_request)
    end

    it 'returns bad_request if first_name is missing' do
      post :create, params: { user: { email: user.email,
                                      password: user.password,
                                      last_name: user.last_name } }
      expect(response).to have_http_status(:bad_request)
    end

    it 'returns bad_request if last_name is missing' do
      post :create, params: { user: { email: user.email,
                                      password: user.password,
                                      first_name: user.first_name } }
      expect(response).to have_http_status(:bad_request)
    end

    it 'returns bad_request if user is invalid and fails to persist' do
      post :create, params: { user: { email: 'abc',
                                      password: user.password,
                                      first_name: user.first_name,
                                      last_name: user.last_name } }
      expect(response).to have_http_status(:bad_request)
    end
  end

  #
  # #GET /users/sign_up
  #
  describe 'get #new' do
    it 'returns not_found' do
      get :new
      expect(response).to have_http_status(:not_found)
    end
  end

  #
  # #GET /users/edit
  #
  describe 'get #edit' do
    it 'returns not_found' do
      get :edit
      expect(response).to have_http_status(:not_found)
    end
  end

  #
  # #PUT /users
  #
  describe 'put #update' do
    it 'returns not_found' do
      put :update
      expect(response).to have_http_status(:not_found)
    end
  end

  #
  # #DELETE /users
  #
  describe 'delete #destroy' do
    it 'returns not_found' do
      delete :destroy
      expect(response).to have_http_status(:not_found)
    end
  end

  #
  # #GET /users/cancel
  #
  describe 'get #cancel' do
    it 'returns not_found' do
      get :cancel
      expect(response).to have_http_status(:not_found)
    end
  end
end
