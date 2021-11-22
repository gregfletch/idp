# frozen_string_literal: true

class Types::UserType < Types::BaseObject
  description 'Represents an application user.'

  field :confirmation_sent_at, GraphQL::Types::ISO8601DateTime, null: true, description: 'The timestamp of when the email confirmation message was sent, in '\
                                                                                         'ISO-8601 format.'
  field :confirmation_token, String, null: true, description: 'A secure token used to confirm a user\'s email address.'
  field :confirmed, Boolean, null: false, description: 'Boolean flag indicating whether or not the user has successfully confirmed their email address.'
  field :confirmed_at, GraphQL::Types::ISO8601DateTime, null: true, description: 'The timestamp when the user confirmed their email address, in ISO-8601 '\
                                                                                 'format.'
  field :created_at, GraphQL::Types::ISO8601DateTime, null: false, description: 'The timestamp of when the user was created, in ISO-8601 format.'
  field :current_sign_in_at, GraphQL::Types::ISO8601DateTime, null: true, description: 'The timestamp of the current successful authentication attempt, in ' \
                                                                                       'ISO-8601 format.'
  field :current_sign_in_ip, String, null: true, description: 'The IP address of the user at the time of the current successful authentication attempt.'
  field :email, String, null: false, description: 'The email address of the user.'
  field :failed_attempts, Integer, null: false, description: 'The number of failed authentication attempts.'
  field :first_name, String, null: false, description: 'The first name of the user.'
  field :full_name, String, null: false, description: 'The full name (first name and last name) of the user.'
  field :id, ID, null: false, description: 'The unique identifier for the user account.'
  field :last_name, String, null: false, description: 'The last name of the user.'
  field :last_sign_in_at, GraphQL::Types::ISO8601DateTime, null: true, description: 'The timestamp of the last successful authentication attempt, in ' \
                                                                                    'ISO-8601 format.'
  field :last_sign_in_ip, String, null: true, description: 'The IP address of the last successful authentication attempt.'
  field :locked_at, GraphQL::Types::ISO8601DateTime, null: true, description: 'The timestamp when the user account became locked due to too many failed ' \
                                                                              'attempts, in ISO-8601 format.'
  field :login_activities, Types::LoginActivityType.connection_type, null: true, description: 'The list of login activities associated with the user account.'
  field :remember_created_at, GraphQL::Types::ISO8601DateTime, null: true, description: 'The timestamp of when the user selected the Remember Me option, in ' \
                                                                                        'ISO-8601 format.'
  field :reset_password_sent_at, GraphQL::Types::ISO8601DateTime, null: true, description: 'The timestamp of when the reset password token was sent to the ' \
                                                                                           'user, in ISO-8601 format.'
  field :reset_password_token, String, null: true, description: 'A secure token used to reset a user password in the event that a user has forgotten their '\
                                                                'password.'
  field :session_id, ID, null: true, description: 'The unique identifier for the current user session.'
  field :sign_in_count, Integer, null: false, description: 'A count of the number of times the user has successfully authenticated.'
  field :unconfirmed_email, String, null: true, description: 'The email associated with the account until it has been confirmed.'
  field :unlock_token, String, null: true, description: 'A secure token used to unlock a user account whose password is locked due to too many failed attempts.'
  field :updated_at, GraphQL::Types::ISO8601DateTime, null: false, description: 'The timestamp when the user account was last modified, in ISO-8601 format.'
  field :username, String, null: false, description: 'The username for the user account.'

  def confirmed
    object.confirmed_at.present?
  end

  def login_activities
    BatchLoader::GraphQL.for(object.id).batch(default_value: [], cache: false, replace_methods: false) do |user_ids, loader|
      LoginActivity.where(user_id: user_ids).order(created_at: :desc).each do |login_activity|
        loader.call(login_activity.user_id) { |memo| memo << login_activity }
      end
    end
  end

  def session_id
    Session.where(user_id: object.id).last&.id
  end
end
