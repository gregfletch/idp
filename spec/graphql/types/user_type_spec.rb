# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Types::UserType do
  let(:field_names) do
    %w[id username firstName lastName fullName createdAt updatedAt email resetPasswordToken resetPasswordSentAt rememberCreatedAt signInCount
       currentSignInAt lastSignInAt currentSignInIp lastSignInIp confirmationToken confirmedAt confirmationSentAt unconfirmedEmail
       failedAttempts unlockToken lockedAt confirmed]
  end

  it 'has 24 fields defined' do
    expect(described_class.fields.keys.count).to eq(24)
  end

  it 'matches the list of field names' do
    expect(described_class.fields.keys).to match_array(field_names)
  end
end
