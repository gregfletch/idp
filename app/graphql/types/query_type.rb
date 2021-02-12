# frozen_string_literal: true

class Types::QueryType < Types::BaseObject
  field :users, [Types::UserType], null: false, description: 'Returns a list of users'

  field :user, Types::UserType, null: true, description: 'Returns the user matching the provided ID or email' do
    argument :email, String, required: false
    argument :id, ID, required: false
  end

  field :login_activities, Types::LoginActivityType.connection_type, null: false, description: 'Returns a list of all login activities' do
    argument :user_id, ID, required: true
    argument :order_by, String, required: false
    argument :direction, String, required: false
  end

  def users
    User.all
  end

  def user(**args)
    return User.find_by!(email: args[:email]) if args[:email].present?
    return User.find(args[:id]) if args[:id].present?

    nil
  rescue ActiveRecord::RecordNotFound
    Rails.logger.error('Unable to find the requested user')
    nil
  end

  def login_activities(**args)
    order = args[:order_by] || 'created_at'
    direction = args[:direction] || 'ASC'

    LoginActivity.where(user_id: args[:user_id]).order("#{order} #{direction}")
  end
end
