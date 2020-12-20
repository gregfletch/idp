# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  let(:name_max_length) { 128 }
  let(:email_max_length) { 255 }
  let(:password_max_length) { name_max_length }
  let(:password_min_length) { 8 }

  it 'is valid with valid attributes' do
    user = build(:user)
    expect(user).to be_valid
  end

  it 'auto-generates a UUID for the ID on create' do
    user = create(:user)
    expect(user.id).to match(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$/i)
  end

  it 'fails validation without first_name' do
    user = build(:user, first_name: nil)
    user.validate
    expect(user.errors[:first_name]).to include('can\'t be blank')
  end

  it 'fails validation if first_name is shorter than minimum length' do
    user = build(:user, first_name: '')
    user.validate
    expect(user.errors[:first_name]).to include('is too short (minimum is 1 character)')
  end

  it 'fails validation if first_name is longer than max length' do
    user = build(:user, first_name: 'a' * (name_max_length + 1))
    user.validate
    expect(user.errors[:first_name]).to include('is too long (maximum is 128 characters)')
  end

  it 'fails validation without last_name' do
    user = build(:user, last_name: nil)
    user.validate
    expect(user.errors[:last_name]).to include('can\'t be blank')
  end

  it 'fails validation if last_name is shorter than minimum length' do
    user = build(:user, last_name: '')
    user.validate
    expect(user.errors[:last_name]).to include('is too short (minimum is 1 character)')
  end

  it 'fails validation if last_name is longer than max length' do
    user = build(:user, last_name: 'a' * (name_max_length + 1))
    user.validate
    expect(user.errors[:last_name]).to include('is too long (maximum is 128 characters)')
  end

  it 'fails validation if username is longer than max length' do
    user = build(:user, username: 'a' * (name_max_length + 1))
    user.validate
    expect(user.errors[:username]).to include('is too long (maximum is 128 characters)')
  end

  it 'fails validation if username is not unique' do
    user = create(:user)
    user_duplicate_username = build(:user, username: user.username)

    user_duplicate_username.validate
    expect(user_duplicate_username.errors[:username]).to include('has already been taken')
  end

  it 'fails validation without email' do
    user = build(:user, email: nil)
    user.validate
    expect(user.errors[:email]).to include('can\'t be blank')
  end

  it 'fails validation if email is shorter than minimum length' do
    user = build(:user, email: '')
    user.validate
    expect(user.errors[:email]).to include('is too short (minimum is 1 character)')
  end

  it 'fails validation if email is longer than max length' do
    user = build(:user, email: "#{'a' * email_max_length}@email.com")
    user.validate
    expect(user.errors[:email]).to include('is too long (maximum is 255 characters)')
  end

  it 'fails validation if email is not unique' do
    user = create(:user)
    user_duplicate_email = build(:user, email: user.email)

    user_duplicate_email.validate
    expect(user_duplicate_email.errors[:email]).to include('has already been taken')
  end

  it 'fails validation if email is not valid' do
    user = build(:user, email: 'abc')

    user.validate
    expect(user.errors[:email]).to include('is invalid')
  end

  it 'fails validation without password' do
    user = build(:user, password: nil)
    user.validate
    expect(user.errors[:password]).to include('can\'t be blank')
  end

  it 'fails validation if password is longer than maximum length' do
    user = build(:user, password: 'a' * (password_max_length + 1))
    user.validate
    expect(user.errors[:password]).to include('is too long (maximum is 128 characters)')
  end

  it 'fails validation if password is shorter than minimum length' do
    user = build(:user, password: 'a' * (password_min_length - 1))
    user.validate
    expect(user.errors[:password]).to include('is too short (minimum is 8 characters)')
  end

  it 'fails validation if password contains too many repeated characters' do
    user = build(:user, password: 'abbbbPass')
    user.validate
    expect(user.errors[:password]).to include('has too many repeated characters')
  end

  it 'fails validation if password contains too many repeated characters (case insensitive)' do
    user = build(:user, password: 'abBBbPass')
    user.validate
    expect(user.errors[:password]).to include('has too many repeated characters')
  end

  it 'fails validation if password contains too many repeated characters (numbers)' do
    user = build(:user, password: 'Password1111')
    user.validate
    expect(user.errors[:password]).to include('has too many repeated characters')
  end

  it 'fails validation if password contains too many repeated characters (symbols)' do
    user = build(:user, password: 'Password!!!!')
    user.validate
    expect(user.errors[:password]).to include('has too many repeated characters')
  end

  it 'fails validation if password contains too many sequential characters' do
    user = build(:user, password: 'passabcd')
    user.validate
    expect(user.errors[:password]).to include('has too many sequential characters')
  end

  it 'fails validation if password contains too many sequential characters (case insensitive)' do
    user = build(:user, password: 'passAbcD')
    user.validate
    expect(user.errors[:password]).to include('has too many sequential characters')
  end

  it 'fails validation if password contains too many sequential characters (numbers)' do
    user = build(:user, password: 'pass1234')
    user.validate
    expect(user.errors[:password]).to include('has too many sequential characters')
  end

  it 'fails validation if password contains too many sequential characters (symbols)' do
    user = build(:user, password: 'pass#$%&')
    user.validate
    expect(user.errors[:password]).to include('has too many sequential characters')
  end

  it 'fails validation if password contains too many sequential characters (reverse)' do
    user = build(:user, password: 'passdcba')
    user.validate
    expect(user.errors[:password]).to include('has too many sequential characters')
  end

  it 'fails validation if password contains too many sequential characters (reverse, insensitive)' do
    user = build(:user, password: 'passDCba')
    user.validate
    expect(user.errors[:password]).to include('has too many sequential characters')
  end

  it 'fails validation if password contains too many sequential characters (reverse, numbers)' do
    user = build(:user, password: 'pass9876')
    user.validate
    expect(user.errors[:password]).to include('has too many sequential characters')
  end

  it 'fails validation if password contains too many sequential characters (reverse, symbols)' do
    user = build(:user, password: 'pass&%$#')
    user.validate
    expect(user.errors[:password]).to include('has too many sequential characters')
  end

  it 'is valid with fewer than 4 reverse sequential characters (index + 1)' do
    user = build(:user, password: 'passDCqa')
    expect(user).to be_valid
  end

  it 'is valid with fewer than 4 reverse sequential characters (index + 2)' do
    user = build(:user, password: 'passDQba')
    expect(user).to be_valid
  end

  it 'is valid with fewer than 4 reverse sequential characters (index + 3)' do
    user = build(:user, password: 'passdcbq')
    expect(user).to be_valid
  end

  it 'is valid with fewer than 4 reverse sequential characters (missing last character)' do
    user = build(:user, password: 'pass1cba')
    expect(user).to be_valid
  end

  it 'fails validation without sign_in_count' do
    user = build(:user, sign_in_count: nil)
    user.validate
    expect(user.errors[:sign_in_count]).to include('can\'t be blank')
  end

  it 'fails validation if sign_in_count is not a number' do
    user = build(:user, sign_in_count: 'a')
    user.validate
    expect(user.errors[:sign_in_count]).to include('is not a number')
  end

  it 'fails validation without failed_attempts' do
    user = build(:user, failed_attempts: nil)
    user.validate
    expect(user.errors[:failed_attempts]).to include('can\'t be blank')
  end

  it 'fails validation if failed_attempts is not a number' do
    user = build(:user, failed_attempts: 'a')
    user.validate
    expect(user.errors[:failed_attempts]).to include('is not a number')
  end

  it 'fails validation if current_sign_in_ip is not an IP address' do
    user = build(:user, current_sign_in_ip: 'a')
    user.validate
    expect(user.errors[:current_sign_in_ip]).to include('is invalid')
  end

  it 'fails validation if last_sign_in_ip is not an IP address' do
    user = build(:user, last_sign_in_ip: 'a')
    user.validate
    expect(user.errors[:last_sign_in_ip]).to include('is invalid')
  end

  it 'sets the username value to email address if no username was provided before saving' do
    user = create(:user, username: nil)
    expect(user.username).to eq(user.email)
  end
end
