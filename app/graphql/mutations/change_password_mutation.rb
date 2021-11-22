# frozen_string_literal: true

class Mutations::ChangePasswordMutation < Mutations::BaseMutation
  description 'A mutation for allowing a user to change their current password.'

  argument :current_password, String, required: true, description: 'The current password associated with the user account.'
  argument :password, String, required: true, description: 'The new password to set for the user account.'

  field :errors, [String], null: false, description: 'The list of error messages resulting from the attempted user update.'
  field :user, Types::UserType, null: true, description: 'The user object to be returned.'

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
