# frozen_string_literal: true

class Types::MutationType < Types::BaseObject
  field :update_user, mutation: Mutations::UpdateUserMutation
end
