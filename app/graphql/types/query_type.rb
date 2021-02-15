# frozen_string_literal: true

class Types::QueryType < Types::BaseObject
  field :users, [Types::UserType], null: false, description: 'Returns a list of users'

  field :user, Types::UserType, null: true, description: 'Returns the user matching the provided ID or email' do
    argument :email, String, required: false
    argument :id, ID, required: false
  end

  field :login_activities, Types::LoginActivityType.connection_type, null: false, description: 'Returns a list of all login activities' do
    argument :order_by, String, required: false
    argument :direction, String, required: false
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

    LoginActivity.where(user_id: context[:current_user].id).order(ActiveRecord::Base.sanitize_sql_for_order("#{order} #{direction}"))
  end
end
