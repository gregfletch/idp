# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable RSpec/MultipleMemoizedHelpers:
RSpec.describe Types::QueryType do
  describe 'users' do
    let!(:users) { create_pair(:user) }
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
        users(email: "#{first_user.email}") {
          id
        }
      })
    end

    let(:query_by_id) do
      %(query {
        users(id: "#{first_user.id}") {
          id
        }
      })
    end

    let(:query_by_id_with_full_name) do
      %(query {
        users(id: "#{first_user.id}") {
          id
          fullName
        }
      })
    end

    let(:query_by_id_with_confirmed) do
      %(query {
        users(id: "#{first_user.id}") {
          id
          confirmed
        }
      })
    end

    let(:query_no_matches) do
      %(query {
        users(id: "#{SecureRandom.uuid}") {
          id
        }
      })
    end

    it 'returns all users' do
      result = IdpSchema.execute(query).as_json
      expect(result.dig('data', 'users')).to match_array(users.map { |user| { id: user.id }.with_indifferent_access })
    end

    it 'returns all users matching email argument' do
      result = IdpSchema.execute(query_by_email).as_json
      expect(result.dig('data', 'users')).to match_array([{ id: first_user.id }.with_indifferent_access])
    end

    it 'returns all users matching id argument' do
      result = IdpSchema.execute(query_by_id).as_json
      expect(result.dig('data', 'users')).to match_array([{ id: first_user.id }.with_indifferent_access])
    end

    it 'sets fullName field as concatenation of first_name and last_name' do
      result = IdpSchema.execute(query_by_id_with_full_name).as_json
      expect(result.dig('data', 'users')).to match_array([{
        id: first_user.id,
        fullName: "#{first_user.first_name} #{first_user.last_name}"
      }.with_indifferent_access])
    end

    it 'sets confirmed field as boolean value' do
      result = IdpSchema.execute(query_by_id_with_confirmed).as_json
      expect(result.dig('data', 'users')).to match_array([{
        id: first_user.id,
        confirmed: first_user.confirmed_at.present?
      }.with_indifferent_access])
    end

    it 'returns an empty array if no matches' do
      result = IdpSchema.execute(query_no_matches).as_json
      expect(result.dig('data', 'users')).to eq([])
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers:
