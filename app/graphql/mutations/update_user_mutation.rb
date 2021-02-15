# frozen_string_literal: true

class Mutations::UpdateUserMutation < Mutations::BaseMutation
  argument :first_name, String, required: false
  argument :last_name, String, required: false

  field :user, Types::UserType, null: true
  field :errors, [String], null: false

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
