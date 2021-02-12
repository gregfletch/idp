# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable RSpec/MultipleMemoizedHelpers:
RSpec.describe Types::QueryType do
  describe 'users' do
    let!(:users) { create_pair(:user, password: 'Password1') }
    let!(:first_user) { users.first }

    let(:query) do
      %(query {
        users {
          id
        }
      })
    end

    let(:query_by_email) do
      %(query {
        user(email: "#{first_user.email}") {
          id
        }
      })
    end

    let(:query_by_id) do
      %(query {
        user(id: "#{first_user.id}") {
          id
        }
      })
    end

    let(:query_by_id_with_full_name) do
      %(query {
        user(id: "#{first_user.id}") {
          id
          fullName
        }
      })
    end

    let(:query_by_id_with_confirmed) do
      %(query {
        user(id: "#{first_user.id}") {
          id
          confirmed
        }
      })
    end

    let(:query_no_matches) do
      %(query {
        user(id: "#{SecureRandom.uuid}") {
          id
        }
      })
    end

    let(:query_no_matches_email) do
      %(query {
        user(email: 'unknown@mail.com') {
          id
        }
      })
    end

    it 'returns all users' do
      result = IdpSchema.execute(query).as_json
      expect(result.with_indifferent_access.dig(:data, :users)).to match_array(users.map { |user| { id: user.id }.with_indifferent_access })
    end

    it 'returns all users matching email argument' do
      result = IdpSchema.execute(query_by_email).as_json
      expect(result.with_indifferent_access.dig(:data, :user)).to eq({ id: first_user.id }.with_indifferent_access)
    end

    it 'returns all users matching id argument' do
      result = IdpSchema.execute(query_by_id).as_json
      expect(result.with_indifferent_access.dig(:data, :user)).to eq({ id: first_user.id }.with_indifferent_access)
    end

    it 'sets fullName field as concatenation of first_name and last_name' do
      result = IdpSchema.execute(query_by_id_with_full_name).as_json
      expect(result.with_indifferent_access.dig(:data, :user)).to eq({
        id: first_user.id,
        fullName: "#{first_user.first_name} #{first_user.last_name}"
      }.with_indifferent_access)
    end

    it 'sets confirmed field as boolean value' do
      result = IdpSchema.execute(query_by_id_with_confirmed).as_json
      expect(result.with_indifferent_access.dig(:data, :user)).to eq({
        id: first_user.id,
        confirmed: first_user.confirmed_at.present?
      }.with_indifferent_access)
    end

    it 'returns null user if no matches by ID' do
      result = IdpSchema.execute(query_no_matches).as_json
      expect(result.with_indifferent_access.dig(:data, :user)).to eq(nil)
    end

    it 'returns null user if no matches by email address' do
      result = IdpSchema.execute(query_no_matches_email).as_json
      expect(result.with_indifferent_access.dig(:data, :user)).to eq(nil)
    end

    # rubocop:disable RSpec/ExampleLength
    it 'returns user with associated login activities if requested by query' do
      create_list(:login_activity, 3, user: first_user)
      create_list(:login_activity, 3)
      login_activity_query = %(query {
        user(id: "#{first_user.id}") {
          id
          loginActivities {
            totalCount
          }
        }
      })

      result = IdpSchema.execute(login_activity_query).as_json
      expect(result.with_indifferent_access.dig(:data, :user, :loginActivities, :totalCount)).to eq(3)
    end
    # rubocop:enable RSpec/ExampleLength
  end

  describe 'login activities' do
    let!(:user) { create(:user, :confirmed_user, password: 'Password1') }
    let!(:login_activities) { create_list(:login_activity, 5, user: user) }

    let(:query) do
      %(query {
        loginActivities(userId: "#{user.id}") {
          totalCount
          edges {
            node {
              id
            }
          }
        }
      })
    end

    let(:query_with_sort) do
      %(query {
        loginActivities(userId: "#{user.id}", orderBy: "id", direction: "DESC") {
          totalCount
          edges {
            node {
              id
            }
          }
        }
      })
    end

    it 'returns the list of login activities for the specified user' do
      result = IdpSchema.execute(query).as_json
      expect(result.with_indifferent_access.dig(:data, :loginActivities, :totalCount)).to eq(login_activities.count)
    end

    it 'returns the list of login activities ordered by created_at ASC by default' do
      login_activity_ids = LoginActivity.order(created_at: :asc).pluck(:id)

      result = IdpSchema.execute(query).as_json
      edges = result.with_indifferent_access.dig(:data, :loginActivities, :edges)
      expect(edges.map { |edge| edge[:node][:id] }).to eq(login_activity_ids)
    end

    it 'returns the list of login activities ordered based on the query parameters' do
      login_activity_ids = LoginActivity.order(id: :desc).pluck(:id)

      result = IdpSchema.execute(query_with_sort).as_json
      edges = result.with_indifferent_access.dig(:data, :loginActivities, :edges)
      expect(edges.map { |edge| edge[:node][:id] }).to eq(login_activity_ids)
    end

    it 'returns error if missing required parameter' do
      bad_query = %(query {
        loginActivities {
          totalCount
        }
      })

      result = IdpSchema.execute(bad_query).as_json
      expect(result.with_indifferent_access[:errors].first[:message]).to eq("Field 'loginActivities' is missing required arguments: userId")
    end

    it 'returns an empty list if no login activities can be found for the provided user ID' do
      bad_query = %(query {
        loginActivities(userId: "#{SecureRandom.uuid}") {
          totalCount
        }
      })

      result = IdpSchema.execute(bad_query).as_json
      expect(result.with_indifferent_access.dig(:data, :loginActivities, :totalCount)).to eq(0)
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers:
