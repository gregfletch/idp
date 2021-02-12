# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Types::LoginActivityType do
  let(:field_names) do
    %w[id scope strategy identity success failureReason userType userId context ip userAgent referrer city region country latitude longitude createdAt
       updatedAt]
  end

  it 'has 19 fields defined' do
    expect(described_class.fields.keys.count).to eq(19)
  end

  it 'matches the list of field names' do
    expect(described_class.fields.keys).to match_array(field_names)
  end
end
