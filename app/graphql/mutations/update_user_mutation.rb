# frozen_string_literal: true

class Mutations::UpdateUserMutation < Mutations::BaseMutation
  description 'A mutation to update basic user information.'

  argument :first_name, String, required: false, description: 'The new first name for the current user.'
  argument :last_name, String, required: false, description: 'The new last name for the current user.'

  field :errors, [String], null: false, description: 'The list of error messages resulting from the attempted user update.'
  field :user, Types::UserType, null: true, description: 'The updated user object to be returned.'

  def resolve(first_name: nil, last_name: nil)
    user = context[:current_user]
    user.first_name = first_name if first_name.present?
    user.last_name = last_name if last_name.present?

    if user.save
      { user: user, errors: [] }
    else
      { errors: user.errors.full_messages }
    end
  end
end
