# frozen_string_literal: true

class Types::UserType < Types::BaseObject
  field :id, ID, null: false
  field :username, String, null: false
  field :first_name, String, null: false
  field :last_name, String, null: false
  field :full_name, String, null: false
  field :created_at, GraphQL::Types::ISO8601DateTime, null: false
  field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  field :email, String, null: false
  field :reset_password_token, String, null: true
  field :reset_password_sent_at, GraphQL::Types::ISO8601DateTime, null: true
  field :remember_created_at, GraphQL::Types::ISO8601DateTime, null: true
  field :sign_in_count, Integer, null: false
  field :current_sign_in_at, GraphQL::Types::ISO8601DateTime, null: true
  field :last_sign_in_at, GraphQL::Types::ISO8601DateTime, null: true
  field :current_sign_in_ip, String, null: true
  field :last_sign_in_ip, String, null: true
  field :confirmation_token, String, null: true
  field :confirmed_at, GraphQL::Types::ISO8601DateTime, null: true
  field :confirmation_sent_at, GraphQL::Types::ISO8601DateTime, null: true
  field :unconfirmed_email, String, null: true
  field :failed_attempts, Integer, null: false
  field :unlock_token, String, null: true
  field :locked_at, GraphQL::Types::ISO8601DateTime, null: true
  field :confirmed, Boolean, null: false

  def confirmed
    object.confirmed_at.present?
  end
end
