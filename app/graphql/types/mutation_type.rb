# frozen_string_literal: true

class Types::MutationType < Types::BaseObject
  # TODO: Implement mutation type for Users
  # field :test_field, String, null: false,
  #                            description: 'An example field added by the generator'
  # def test_field
  #   'Hello World'
  # end

  field :update_user, mutation: Mutations::UpdateUserMutation
end
