# frozen_string_literal: true

class Mutations::UnlockPasswordMutation < Mutations::BaseMutation
  description 'A mutation to unlock a user password which has become locked due to too many failed authentication attempts.'

  argument :email, String, required: false, description: 'The email address associated with the user account.'
  argument :unlock_token, String, required: false, description: 'The secure token used to unlock the user account.'

  field :errors, [String], null: false, description: 'The list of error messages resulting from the attempted user update.'
  field :user, Types::UserType, null: true, description: 'The user object to be returned.'

  def resolve(**args)
    validation_result = validate_params(args)
    return validation_result if validation_result.present?
    return initiate_unlock(args[:email]) if args[:email].present?

    unlock_password(args[:unlock_token])
  end

  private

  def initiate_unlock(email)
    user = User.find_by(email: email)
    return { errors: ['Unknown user email address'] } if user.blank?

    user = User.send_unlock_instructions({ email: email })
    { user: user, errors: [] }
  end

  def unlock_password(unlock_token)
    user = User.unlock_access_by_token(unlock_token)
    if user.errors.blank?
      { user: user, errors: [] }
    else
      { errors: user.errors.full_messages }
    end
  end

  def validate_params(args)
    return { errors: ['Unlock password token or email address is required'] } if args[:unlock_token].blank? && args[:email].blank?

    nil
  end
end
