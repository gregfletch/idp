# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::UnlockPasswordMutation do
  let(:user) { create(:user, :confirmed_user, password: 'Password1') }
  let(:unlock_token) { Devise.token_generator.generate(User, :unlock_token) }
  let!(:locked_user) { create(:user, :confirmed_user, password: 'Password1', locked_at: Time.now.utc.iso8601, unlock_token: unlock_token.last) }
  let(:unknown_unlock_token) { Devise.token_generator.generate(User, :unlock_token) }

  let(:request_unlock_password_mutation) do
    %(mutation {
      unlockPassword(email: "#{user.email}") {
        user {
          id
        }
        errors
      }
    })
  end

  let(:unlock_password_mutation) do
    %(mutation {
      unlockPassword(unlockToken: "#{unlock_token.first}") {
        user {
          id
        }
        errors
      }
    })
  end

  let(:unlock_password_mutation_unknown_unlock_token) do
    %(mutation {
      unlockPassword(unlockToken: "#{unknown_unlock_token.first}") {
        user {
          id
        }
        errors
      }
    })
  end

  let(:invalid_unlock_password_mutation) do
    %(mutation {
      unlockPassword {
        user {
          id
        }
        errors
      }
    })
  end

  it 'returns the requested user attributes when sending unlock password notification' do
    result = IdpSchema.execute(request_unlock_password_mutation).as_json
    expect(result.with_indifferent_access.dig(:data, :unlockPassword, :user)).to eq({ id: user.id }.with_indifferent_access)
  end

  it 'returns the requested user attributes after unlocking a user password' do
    result = IdpSchema.execute(unlock_password_mutation).as_json
    expect(result.with_indifferent_access.dig(:data, :unlockPassword, :user)).to eq({ id: locked_user.id }.with_indifferent_access)
  end

  it 'returns an error if missing unlock token/email' do
    result = IdpSchema.execute(invalid_unlock_password_mutation).as_json
    expect(result.with_indifferent_access.dig(:data, :unlockPassword, :errors).first).to eq('Unlock password token or email address is required')
  end

  it 'returns an error if unlock token is unknown' do
    result = IdpSchema.execute(unlock_password_mutation_unknown_unlock_token).as_json
    expect(result.with_indifferent_access.dig(:data, :unlockPassword, :errors).first).to eq('Unlock token is invalid')
  end
end
