# frozen_string_literal: true

class Types::MutationType < Types::BaseObject
  field :change_password, mutation: Mutations::ChangePasswordMutation
  field :reset_password, mutation: Mutations::ResetPasswordMutation
  field :unlock_password, mutation: Mutations::UnlockPasswordMutation
  field :update_user, mutation: Mutations::UpdateUserMutation
end
