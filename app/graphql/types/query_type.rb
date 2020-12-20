# frozen_string_literal: true

class Types::QueryType < Types::BaseObject
  field :users, [Types::UserType], null: false, description: 'Returns a list of users' do
    argument :email, String, required: false
    argument :id, ID, required: false
  end

  def users(**args)
    return User.where(email: args[:email]) if args[:email].present?
    return [User.find(args[:id])] if args[:id].present?

    User.all
  rescue ActiveRecord::RecordNotFound
    []
  end
end
