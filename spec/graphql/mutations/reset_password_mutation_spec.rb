# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::ResetPasswordMutation do
  let(:user) { create(:user, :confirmed_user, password: 'Password1') }
  let(:reset_password_token) { Devise.token_generator.generate(User, :reset_password_token) }
  let!(:reset_user) do
    create(:user, :confirmed_user, password: 'Password1', reset_password_sent_at: Time.now.utc.iso8601, reset_password_token: reset_password_token.last)
  end
  let(:reset_password_token_expired) { Devise.token_generator.generate(User, :reset_password_token) }
  # rubocop:disable RSpec/LetSetup
  let!(:reset_user_expired_reset_token) do
    create(:user, :confirmed_user, password: 'Password1', reset_password_sent_at: 1.year.ago.utc.iso8601,
                                   reset_password_token: reset_password_token_expired.last)
  end
  # rubocop:enable RSpec/LetSetup

  let(:request_reset_password_mutation) do
    %(mutation {
      resetPassword(email: "#{user.email}") {
        user {
          id
        }
        errors
      }
    })
  end

  let(:reset_password_mutation) do
    %(mutation {
      resetPassword(resetToken: "#{reset_password_token.first}", password: "Password1") {
        user {
          id
          sessionId
        }
        errors
      }
    })
  end

  let(:reset_password_mutation_invalid_password) do
    %(mutation {
      resetPassword(resetToken: "#{reset_password_token.first}", password: "#{'a' * 8}") {
        user {
          id
          sessionId
        }
        errors
      }
    })
  end

  it 'returns an error if email argument is missing when initiating a password reset' do
    error_mutation = %(mutation {
      resetPassword {
        user {
          id
        }
        errors
      }
    })
    result = IdpSchema.execute(error_mutation).as_json
    expect(result.with_indifferent_access.dig(:data, :resetPassword, :errors).first).to eq('Missing email address')
  end

  it 'returns an error if password argument is missing when performing a password reset' do
    error_mutation = %(mutation {
      resetPassword(resetToken: "#{Devise.token_generator.generate(User, :reset_password_token).first}") {
        user {
          id
        }
        errors
      }
    })
    result = IdpSchema.execute(error_mutation).as_json
    expect(result.with_indifferent_access.dig(:data, :resetPassword, :errors).first).to eq('Missing password')
  end

  it 'returns an error if reset_token argument is missing when performing a password reset' do
    error_mutation = %(mutation {
      resetPassword(password: "Password1") {
        user {
          id
        }
        errors
      }
    })
    result = IdpSchema.execute(error_mutation).as_json
    expect(result.with_indifferent_access.dig(:data, :resetPassword, :errors).first).to eq('Missing reset password token')
  end

  it 'returns an error if reset_token is unknown' do
    error_mutation = %(mutation {
      resetPassword(password: "Password1", resetToken: "#{Devise.token_generator.generate(User, :reset_password_token).first}") {
        user {
          id
        }
        errors
      }
    })
    result = IdpSchema.execute(error_mutation).as_json
    expect(result.with_indifferent_access.dig(:data, :resetPassword, :errors).first).to eq('Reset password token is invalid')
  end

  it 'returns an error if reset_token is expired' do
    error_mutation = %(mutation {
      resetPassword(password: "Password1", resetToken: "#{reset_password_token_expired.first}") {
        user {
          id
        }
        errors
      }
    })
    result = IdpSchema.execute(error_mutation).as_json
    expect(result.with_indifferent_access.dig(:data, :resetPassword, :errors).first).to eq('Reset password token has expired, please request a new one')
  end

  it 'returns the requested user attributes when sending reset password notification' do
    result = IdpSchema.execute(request_reset_password_mutation).as_json
    expect(result.with_indifferent_access.dig(:data, :resetPassword, :user)).to eq({ id: user.id }.with_indifferent_access)
  end

  it 'sends an email to the provided email address when initiating a password reset' do
    expect { IdpSchema.execute(request_reset_password_mutation) }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  it 'resets the user\'s password' do
    result = IdpSchema.execute(reset_password_mutation).as_json
    expect(result.with_indifferent_access.dig(:data, :resetPassword, :user, :id)).to eq(reset_user.id)
  end

  it 'returns the session ID if user is signed in after reset' do
    result = IdpSchema.execute(reset_password_mutation).as_json
    expect(result.with_indifferent_access.dig(:data, :resetPassword, :user, :sessionId)).to eq(Session.last.id)
  end

  it 'does not return the session ID if user is not signed in after reset' do
    allow(Devise).to receive(:sign_in_after_reset_password).and_return(false)
    result = IdpSchema.execute(reset_password_mutation).as_json
    expect(result.with_indifferent_access.dig(:data, :resetPassword, :user, :sessionId)).to be_nil
  end

  it 'returns an error if the new password is invalid' do
    result = IdpSchema.execute(reset_password_mutation_invalid_password).as_json
    expect(result.with_indifferent_access.dig(:data, :resetPassword, :errors).count).to eq(1)
  end

  it 'returns an error if the user cannot be found by email' do
    mutation = %(mutation {
      resetPassword(email: "unknown@mail.com") {
        user {
          id
        }
        errors
      }
    })
    result = IdpSchema.execute(mutation).as_json
    expect(result.with_indifferent_access.dig(:data, :resetPassword, :errors).first).to eq('Unknown user email address')
  end
end
