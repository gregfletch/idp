# frozen_string_literal: true

class Types::MutationType < Types::BaseObject
  description 'Defines the set of mutations that can be performed as part of this application.'

  field :change_password, mutation: Mutations::ChangePasswordMutation, description: 'A mutation to change a user\'s password.'
  field :reset_password, mutation: Mutations::ResetPasswordMutation, description: 'A mutation to reset a user\'s password.'
  field :unlock_password, mutation: Mutations::UnlockPasswordMutation, description: 'A mutation to unlock a user\'s password.'
  field :update_user, mutation: Mutations::UpdateUserMutation, description: 'A mutation to update user information.'
end
