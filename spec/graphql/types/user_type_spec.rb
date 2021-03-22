# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Types::UserType do
  let(:field_names) do
    %w[confirmationSentAt confirmationToken confirmed confirmedAt createdAt currentSignInAt currentSignInIp email failedAttempts firstName fullName id lastName
       lastSignInAt lastSignInIp unlockToken lockedAt loginActivities rememberCreatedAt resetPasswordSentAt resetPasswordToken sessionId signInCount
       unconfirmedEmail updatedAt username]
  end

  it 'has 25 fields defined' do
    expect(described_class.fields.keys.count).to eq(26)
  end

  it 'matches the list of field names' do
    expect(described_class.fields.keys).to match_array(field_names)
  end
end
