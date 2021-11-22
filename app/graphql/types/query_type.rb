# frozen_string_literal: true

class Types::QueryType < Types::BaseObject
  description 'Defines the list of queries which can be performed and the required and optional fields that can be used to filter query results.'

  field :users, [Types::UserType], null: false, description: 'Returns a list of users'

  field :user, Types::UserType, null: true, description: 'Returns the user matching the provided ID or email' do
    argument :email, String, required: false, description: 'The email address of the user.'
    argument :id, ID, required: false, description: 'The unique identifier of the user.'
  end

  field :login_activities, Types::LoginActivityType.connection_type, null: false, description: 'Returns a list of all login activities' do
    argument :direction, String, required: false, description: 'The direction to order the list of login activities.'
    argument :order_by, String, required: false, description: 'The column name to order the list of login activities by.'
  end

  def users
    User.all
  end

  def user(**args)
    return User.find_by!(email: args[:email]) if args[:email].present?
    return User.find(args[:id]) if args[:id].present?

    context[:current_user]
  rescue ActiveRecord::RecordNotFound
    Rails.logger.error('Unable to find the requested user')
    nil
  end

  def login_activities(**args)
    order = args[:order_by]
    direction = args[:direction] || :desc

    order = :created_at if order.blank? || LoginActivity.column_names.exclude?(order)

    LoginActivity.for_user(context[:current_user]).order(ActiveRecord::Base.sanitize_sql_for_order("#{order} #{direction}"))
  end
end
