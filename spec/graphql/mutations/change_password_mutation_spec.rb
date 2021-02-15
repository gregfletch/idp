# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::ChangePasswordMutation do
  let(:user) { create(:user, :confirmed_user, password: 'Password1') }

  let(:mutation) do
    %(mutation {
      changePassword(password: "NewPassword", currentPassword: "Password1") {
        user {
          id
        }
        errors
      }
    })
  end

  let(:mutation_incorrect_current_password) do
    %(mutation {
      changePassword(password: "NewPassword", currentPassword: "WrongPassword") {
        user {
          id
        }
        errors
      }
    })
  end

  let(:mutation_invalid_new_password) do
    %(mutation {
      changePassword(password: "#{'a' * 129}", currentPassword: "Password1") {
        user {
          id
        }
        errors
      }
    })
  end

  it 'returns the the requested user info on success' do
    result = IdpSchema.execute(mutation, context: { current_user: user }).as_json
    expect(result.with_indifferent_access.dig(:data, :changePassword, :user)).to eq({ id: user.id }.with_indifferent_access)
  end

  it 'does not return a user object on error' do
    result = IdpSchema.execute(mutation_incorrect_current_password, context: { current_user: user }).as_json
    expect(result.with_indifferent_access.dig(:data, :changePassword, :user)).to be_nil
  end

  it 'returns error if new password is invalid' do
    result = IdpSchema.execute(mutation_invalid_new_password, context: { current_user: user }).as_json
    expect(result.with_indifferent_access.dig(:data, :changePassword, :errors).count).to eq(1)
  end
end
