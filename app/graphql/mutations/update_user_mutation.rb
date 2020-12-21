# frozen_string_literal: true

class Mutations::UpdateUserMutation < Mutations::BaseMutation
  argument :id, ID, required: true
  argument :first_name, String, required: false
  argument :last_name, String, required: false

  field :user, Types::UserType, null: true
  field :errors, [String], null: false

  def resolve(id:, first_name: nil, last_name: nil)
    user = User.find(id)
    user.first_name = first_name if first_name.present?
    user.last_name = last_name if last_name.present?

    if user.save
      { user: user, errors: [] }
    else
      { errors: user.errors.full_messages }
    end
  end
end
