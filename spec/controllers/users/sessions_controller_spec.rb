# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::SessionsController do
  before do
    # rubocop:disable RSpec/InstanceVariable
    @request.env['devise.mapping'] = Devise.mappings[:user]
    # rubocop:enable RSpec/InstanceVariable
  end

  let(:user) { create(:user, :confirmed_user, password: 'Password1') }
  let(:params) do
    {
      user: {
        email: user.email,
        password: user.password
      }
    }
  end

  #
  # #POST /users/sign_in
  #
  describe 'sign_in' do
    it 'returns ok on success' do
      post :create, params: params
      expect(response).to have_http_status(:ok)
    end

    it 'sets the current_sign_in_at timestamp on success' do
      post :create, params: params
      expect(User.last.current_sign_in_at).not_to be_nil
    end

    it 'returns a well-defined response format on success' do
      post :create, params: params
      session = user.reload.sessions.last
      expect(JSON.parse(response.body, symbolize_names: true)).to eq({ result: { message: 'Success', user: { id: user.id, session_id: session.id } } })
    end

    it 'sets the current_sign_in_ip  on success' do
      post :create, params: params
      expect(User.last.current_sign_in_ip).to match(Resolv::IPv4::Regex)
    end

    it 'sets the last_sign_in_at timestamp to the previous current_sign_in_at value on success' do
      sign_in_timestamp = Time.now.utc.iso8601
      user.update!(current_sign_in_at: sign_in_timestamp)
      post :create, params: params
      expect(User.last.last_sign_in_at).to eq(sign_in_timestamp)
    end

    it 'sets the last_sign_in_ip to the previous current_sign_in_ip value on success' do
      ip_address = Faker::Internet.ip_v4_address
      user.update!(current_sign_in_ip: ip_address)
      post :create, params: params
      expect(User.last.last_sign_in_ip).to eq(ip_address)
    end

    it 'returns JSON object with success message on success' do
      post :create, params: params
      expect(JSON.parse(response.body, symbolize_names: true)[:result][:message]).to eq('Success')
    end

    it 'returns unauthorized if missing required parameters' do
      post :create
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns unauthorized if parameters is empty hash' do
      post :create, params: {}
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns unauthorized if user parameter is empty hash' do
      post :create, params: { user: {} }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns unauthorized if email is missing' do
      post :create, params: { user: { password: user.password } }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns unauthorized if password is missing' do
      post :create, params: { user: { email: user.email } }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns unauthorized if unknown user attempts to login' do
      post :create, params: { user: { email: Faker::Internet.email, password: user.password } }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns unauthorized if password is incorrect' do
      post :create, params: { user: { email: user.email, password: Faker::Internet.password } }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns unauthorized if user is unconfirmed' do
      unconfirmed_user = create(:user)
      post :create, params: { user: { email: unconfirmed_user.email, password: unconfirmed_user.password } }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns ok if user is already authenticated' do
      post :create, params: { user: { email: user.email, password: user.password } }
      post :create, params: { user: { email: user.email, password: user.password } }
      expect(response).to have_http_status(:ok)
    end

    it 'increments the login activities count on authentication attempts' do
      expect { post :create, params: params }.to change(LoginActivity, :count).by(1)
    end

    it 'increments the login activities count for the user on authentication attempts' do
      expect { post :create, params: params }.to change(user.login_activities, :count).by(1)
    end
  end

  #
  # #DELETE /users/sign_out
  #
  describe 'sign_out' do
    context 'when unauthorized' do
      it 'returns unauthorized if no access token included the Authorization header' do
        delete :destroy
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns forbidden if provided scopes are invalid' do
        access_token = create(:doorkeeper_access_token, scopes: 'api:unknown', resource_owner_id: user.id)
        allow(controller).to receive(:doorkeeper_token) { access_token }
        request.headers[:Authorization] = "Bearer #{access_token}"
        delete :destroy
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when authorized' do
      let(:access_token) { create(:doorkeeper_access_token, resource_owner_id: user.id) }

      before do
        allow(controller).to receive(:doorkeeper_token) { access_token }
        request.headers[:Authorization] = "Bearer #{access_token.token}"
      end

      it 'returns no_content if sign_out is called with no active session' do
        delete :destroy
        expect(response).to have_http_status(:no_content)
      end

      it 'returns no_content on success' do
        post :create, params: params

        delete :destroy
        expect(response).to have_http_status(:no_content)
      end

      it 'returns no_content if only signing out user scope' do
        allow(Devise).to receive(:sign_out_all_scopes).and_return(false)

        post :create, params: params

        delete :destroy
        expect(response).to have_http_status(:no_content)
      end
    end
  end

  #
  # #GET /users/sign_in
  #
  describe 'get #new' do
    it 'returns not_found' do
      get :new
      expect(response).to have_http_status(:not_found)
    end
  end
end
