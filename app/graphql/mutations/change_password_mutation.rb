# frozen_string_literal: true

class Mutations::ChangePasswordMutation < Mutations::BaseMutation
  argument :current_password, String, required: true
  argument :password, String, required: true

  field :user, Types::UserType, null: true
  field :errors, [String], null: false

  def resolve(**args)
    return { errors: ['New password cannot be the same as the current password'] } if args[:current_password] == args[:password]

    user = context[:current_user]
    return { errors: ['Current password is incorrect'] } unless user.active_for_authentication? && user.valid_password?(args[:current_password])

    user.password = args[:password]
    if user.save
      { user: user, errors: [] }
    else
      { errors: user.errors.full_messages }
    end
  end
end
