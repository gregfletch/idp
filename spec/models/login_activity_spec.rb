# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoginActivity do
  it 'is valid with valid attributes' do
    login_activity = build(:login_activity)
    expect(login_activity).to be_valid
  end

  it 'auto-generates a UUID for the ID on create' do
    login_activity = create(:login_activity)
    expect(login_activity.id).to match(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$/i)
  end

  it 'belongs to a User' do
    login_activity = create(:login_activity)
    expect(login_activity.user).to be_instance_of(User)
  end

  it 'can get User object that the login activity belongs to' do
    user = create(:user)
    login_activity = create(:login_activity, user: user)

    expect(login_activity.user.id).to eq(user.id)
  end
end
