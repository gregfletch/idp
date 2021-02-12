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
  field :login_activities, Types::LoginActivityType.connection_type, null: true

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
end
