# frozen_string_literal: true

require 'rails_helper'

describe GraphqlController do
  describe 'post #execute' do
    context 'when unauthorized' do
      let(:user) { create(:user, :confirmed_user, :skip_validate) }

      it 'returns unauthorized if no access token included the Authorization header' do
        post :execute
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns unauthorized if provided scopes are invalid' do
        access_token = create(:doorkeeper_access_token, scopes: 'api:unknown', resource_owner_id: user.id)
        allow(controller).to receive(:doorkeeper_token) { access_token }
        request.headers[:Authorization] = "Bearer #{access_token}"
        post :execute
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns forbidden if email variable does not match current user email' do
        access_token = create(:doorkeeper_access_token, resource_owner_id: user.id)
        allow(controller).to receive(:doorkeeper_token) { access_token }
        request.headers[:Authorization] = "Bearer #{access_token}"
        post :execute, params: { variables: { email: 'unknown.user@mail.com' } }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns forbidden if id variable does not match current user id' do
        access_token = create(:doorkeeper_access_token, resource_owner_id: user.id)
        allow(controller).to receive(:doorkeeper_token) { access_token }
        request.headers[:Authorization] = "Bearer #{access_token}"
        post :execute, params: { variables: { id: SecureRandom.uuid } }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authorized' do
      let(:user) { create(:user, :confirmed_user, :skip_validate) }
      let(:access_token) { create(:doorkeeper_access_token, resource_owner_id: user.id) }

      before do
        allow(controller).to receive(:doorkeeper_token) { access_token }
      end

      describe 'user query' do
        let(:query) do
          'query {
            users {
              id
              fullName
            }
          }'
        end

        let(:query_email_variable) do
          'query($email: String) {
            user(email: $email) {
              id
              fullName
            }
          }'
        end

        let(:query_id_variable) do
          'query($id: ID) {
            user(id: $id) {
              id
              fullName
            }
          }'
        end

        it 'returns ok on success' do
          request.headers[:Authorization] = "Bearer #{access_token}"
          post :execute
          expect(response).to have_http_status(:ok)
        end

        it 'returns list of all users when no variables provided' do
          create_list(:user, 5, :skip_validate)
          request.headers[:Authorization] = "Bearer #{access_token}"
          post :execute, params: { query: query }
          expect(JSON.parse(response.body, symbolize_names: true).dig(:data, :users).count).to eq(6)
        end

        it 'returns a single user result matching the provided email variable' do
          create_list(:user, 5, :skip_validate)
          request.headers[:Authorization] = "Bearer #{access_token}"
          post :execute, params: { query: query_email_variable, variables: { email: user.email } }
          expect(JSON.parse(response.body, symbolize_names: true).dig(:data, :user, :id)).to eq(user.id)
        end

        it 'returns a user object matching the email variable containing only the requested attributes' do
          create_list(:user, 5, :skip_validate)
          request.headers[:Authorization] = "Bearer #{access_token}"
          post :execute, params: { query: query_email_variable, variables: { email: user.email } }
          expected_result = { id: user.id, fullName: user.full_name }
          expect(JSON.parse(response.body, symbolize_names: true).dig(:data, :user)).to eq(expected_result)
        end

        it 'returns a single user result matching the provided id variable' do
          create_list(:user, 5, :skip_validate)
          request.headers[:Authorization] = "Bearer #{access_token}"
          post :execute, params: { query: query_id_variable, variables: { id: user.id } }
          expect(JSON.parse(response.body, symbolize_names: true).dig(:data, :user, :id)).to eq(user.id)
        end

        it 'returns a user object matching the id variable containing only the requested attributes' do
          create_list(:user, 5, :skip_validate)
          request.headers[:Authorization] = "Bearer #{access_token}"
          post :execute, params: { query: query_id_variable, variables: { id: user.id } }
          expected_result = { id: user.id, fullName: user.full_name }
          expect(JSON.parse(response.body, symbolize_names: true).dig(:data, :user)).to eq(expected_result)
        end

        it 'returns matching user when variable is a String' do
          request.headers[:Authorization] = "Bearer #{access_token}"
          post :execute, params: { query: query_id_variable, variables: { id: user.id }.to_json }
          expected_result = { id: user.id, fullName: user.full_name }
          expect(JSON.parse(response.body, symbolize_names: true).dig(:data, :user)).to eq(expected_result)
        end

        it 'returns matching user when variable is a Hash' do
          request.headers[:Authorization] = "Bearer #{access_token}"
          post :execute, params: { query: query_id_variable, variables: { id: user.id }.to_h }
          expected_result = { id: user.id, fullName: user.full_name }
          expect(JSON.parse(response.body, symbolize_names: true).dig(:data, :user)).to eq(expected_result)
        end

        it 'returns null user if no variable passed to user query' do
          create_list(:user, 5, :skip_validate)
          request.headers[:Authorization] = "Bearer #{access_token}"
          post :execute, params: { query: query_id_variable, variables: '' }
          expect(JSON.parse(response.body, symbolize_names: true).dig(:data, :user)).to be_nil
        end

        it 'returns null user for unknown user ID' do
          create_list(:user, 5, :skip_validate)
          request.headers[:Authorization] = "Bearer #{access_token}"
          post :execute, params: { query: query_id_variable, variables: { id: SecureRandom.uuid }.to_h }
          expect(JSON.parse(response.body, symbolize_names: true).dig(:data, :user)).to be_nil
        end

        it 'returns null user for unknown user email' do
          create_list(:user, 5, :skip_validate)
          request.headers[:Authorization] = "Bearer #{access_token}"
          post :execute, params: { query: query_id_variable, variables: { email: 'unknown@mail.com' }.to_h }
          expect(JSON.parse(response.body, symbolize_names: true).dig(:data, :user)).to be_nil
        end

        # rubocop:disable RSpec/ExampleLength
        it 'returns list of login activities for the user if requested' do
          query = 'query($id: ID) {
            user(id: $id) {
              id
              fullName
              loginActivities {
                totalCount
              }
            }
          }'

          create_list(:login_activity, 3)
          create_list(:login_activity, 3, user: user)
          request.headers[:Authorization] = "Bearer #{access_token}"
          post :execute, params: { query: query, variables: { id: user.id }.to_h }
          expect(JSON.parse(response.body, symbolize_names: true).dig(:data, :user, :loginActivities, :totalCount)).to eq(3)
        end
        # rubocop:enable RSpec/ExampleLength

        # rubocop:disable RSpec/ExampleLength
        it 'returns the login activity context' do
          query = 'query($id: ID) {
            user(id: $id) {
              id
              fullName
              loginActivities {
                edges {
                  node {
                    id
                    context
                  }
                }
              }
            }
          }'

          login_activity = create(:login_activity, user: user)
          request.headers[:Authorization] = "Bearer #{access_token}"
          post :execute, params: { query: query, variables: { id: user.id }.to_h }
          expect(JSON.parse(response.body, symbolize_names: true).dig(:data, :user, :loginActivities,
                                                                      :edges).first[:node][:context]).to eq(login_activity.context)
        end
        # rubocop:enable RSpec/ExampleLength

        it 'returns an error on invalid query' do
          invalid_query = 'query {
            invalid {
              id
              unknown
            }
          }'

          request.headers[:Authorization] = "Bearer #{access_token}"
          post :execute, params: { query: invalid_query }
          expect(JSON.parse(response.body, symbolize_names: true)[:errors]).not_to be_nil
        end

        it 'returns bad_request when an error is raised when processing query' do
          allow(IdpSchema).to receive(:execute).and_raise(StandardError)
          request.headers[:Authorization] = "Bearer #{access_token}"
          post :execute, params: { query: query }
          expect(response).to have_http_status(:bad_request)
        end

        it 'returns errors object when an error is raised when processing query' do
          allow(IdpSchema).to receive(:execute).and_raise(StandardError)
          request.headers[:Authorization] = "Bearer #{access_token}"
          post :execute, params: { query: query }
          expect(JSON.parse(response.body, symbolize_names: true)[:errors]).not_to be_nil
        end
      end

      describe 'user mutation' do
        let(:mutation) do
          'mutation ($id: ID!, $firstName: String, $lastName: String) {
            updateUser(id: $id, firstName: $firstName, lastName: $lastName) {
              user {
                id
                fullName
              }
              errors
            }
          }'
        end

        it 'returns ok on success' do
          request.headers[:Authorization] = "Bearer #{access_token}"
          post :execute, params: { query: mutation, variables: { id: user.id } }
          expect(response).to have_http_status(:ok)
        end

        it 'response does not contain errors on success' do
          request.headers[:Authorization] = "Bearer #{access_token}"
          post :execute, params: { query: mutation, variables: { id: user.id } }
          expect(JSON.parse(response.body, symbolize_names: true).dig(:data, :updateUser, :errors)).to eq([])
        end

        it 'user is unchanged if no variables provided to change attributes' do
          request.headers[:Authorization] = "Bearer #{access_token}"
          full_name = user.full_name
          post :execute, params: { query: mutation, variables: { id: user.id } }
          expect(user.reload.full_name).to eq(full_name)
        end

        it 'user is updated on successful mutation' do
          request.headers[:Authorization] = "Bearer #{access_token}"
          post :execute, params: { query: mutation, variables: { id: user.id, firstName: 'Updated', lastName: 'Name' } }
          expect(user.reload.full_name).to eq('Updated Name')
        end

        it 'does not update user on invalid mutation' do
          request.headers[:Authorization] = "Bearer #{access_token}"
          expected_result = user.full_name
          post :execute, params: { query: mutation, variables: { id: user.id, firstName: 'a' * 129, lastName: 'Name' } }
          expect(user.reload.full_name).to eq(expected_result)
        end

        it 'returns errors on invalid mutation' do
          request.headers[:Authorization] = "Bearer #{access_token}"
          post :execute, params: { query: mutation, variables: { id: user.id, firstName: 'a' * 129, lastName: 'Name' } }
          expect(JSON.parse(response.body, symbolize_names: true).dig(:data, :updateUser, :errors).count).not_to eq(0)
        end
      end
    end
  end
end
