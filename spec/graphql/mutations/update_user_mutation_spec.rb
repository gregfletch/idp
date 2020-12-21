# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::UpdateUserMutation do
  let(:user) { create(:user) }
  let(:query) do
    %(mutation {
      updateUser(id: "#{user.id}", firstName: "Modified", lastName: "Updated") {
        user {
          id
          fullName
        }
        errors
      }
    })
  end

  let(:query_update_last_name) do
    %(mutation {
      updateUser(id: "#{user.id}", firstName: null, lastName: "Updated") {
        user {
          id
          fullName
        }
        errors
      }
    })
  end

  let(:query_update_first_name) do
    %(mutation {
      updateUser(id: "#{user.id}", firstName: "Modified", lastName: null) {
        user {
          id
          fullName
        }
        errors
      }
    })
  end

  let(:query_invalid_params) do
    %(mutation {
      updateUser(id: "#{user.id}", firstName: "#{'a' * 129}", lastName: "#{'b' * 129}") {
        user {
          id
          fullName
        }
        errors
      }
    })
  end

  it 'returns the modified user on success' do
    result = IdpSchema.execute(query).as_json
    expect(result.with_indifferent_access.dig(:data, :updateUser, :user)).to eq({ id: user.id, fullName: 'Modified Updated' }.with_indifferent_access)
  end

  it 'modifies the user object on success' do
    expect do
      IdpSchema.execute(query).as_json
      user.reload
    end.to change(user, :full_name).to 'Modified Updated'
  end

  it 'returns the modified user on success when only the first name is provided' do
    result = IdpSchema.execute(query_update_first_name).as_json
    expect(result.with_indifferent_access.dig(:data, :updateUser, :user)).to eq({ id: user.id, fullName: "Modified #{user.last_name}" }.with_indifferent_access)
  end

  it 'modifies the user first name on success when only the first name is provided' do
    expect do
      IdpSchema.execute(query_update_first_name).as_json
      user.reload
    end.to change(user, :first_name).to 'Modified'
  end

  it 'does not modify the user last name on success when only the first name is provided' do
    expect do
      IdpSchema.execute(query_update_first_name).as_json
      user.reload
    end.not_to change(user, :last_name)
  end

  it 'returns the modified user on success when only the last name is provided' do
    result = IdpSchema.execute(query_update_last_name).as_json
    expect(result.with_indifferent_access.dig(:data, :updateUser, :user)).to eq({ id: user.id, fullName: "#{user.first_name} Updated" }.with_indifferent_access)
  end

  it 'modifies the user last name on success when only the last name is provided' do
    expect do
      IdpSchema.execute(query_update_last_name).as_json
      user.reload
    end.to change(user, :last_name).to 'Updated'
  end

  it 'does not modify the user first name on success when only the last name is provided' do
    expect do
      IdpSchema.execute(query_update_last_name).as_json
      user.reload
    end.not_to change(user, :first_name)
  end

  it 'returns an empty array for errors on success' do
    result = IdpSchema.execute(query).as_json
    expect(result.with_indifferent_access.dig(:data, :updateUser, :errors)).to eq([])
  end

  it 'returns an array of errors for each error when update fails' do
    result = IdpSchema.execute(query_invalid_params).as_json
    expect(result.with_indifferent_access.dig(:data, :updateUser, :errors).count).to eq(2)
  end
end
