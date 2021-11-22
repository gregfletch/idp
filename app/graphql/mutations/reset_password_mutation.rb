# frozen_string_literal: true

class Mutations::ResetPasswordMutation < Mutations::BaseMutation
  description 'A mutation for resetting a user password for a user who has forgotten their current password.'

  argument :email, String, required: false, description: 'The email address associated with the user account.'
  argument :password, String, required: false, description: 'The new password value that the user wishes to set.'

  # rubocop:disable GraphQL/ExtractInputType
  argument :reset_token, String, required: false, description: 'The secure token used to reset the user password.'
  # rubocop:enable GraphQL/ExtractInputType

  field :errors, [String], null: false, description: 'The list of error messages resulting from the attempted user update.'
  field :user, Types::UserType, null: true, description: 'The user object to be returned.'

  def resolve(**args)
    validation_result = validate_params(args)
    return validation_result if validation_result.present?

    user = User.find_by(email: args[:email])
    return { errors: ['Unknown user email address'] } if args[:email].present? && user.blank?

    if user.present?
      user.send_reset_password_instructions
      return { user: user, errors: [] }
    end

    reset_password(args[:password], args[:reset_token])
  end

  private

  def reset_password(password, reset_token)
    user = User.reset_password_by_token({ password: password, password_confirmation: password, reset_password_token: reset_token })
    if user.errors.blank?
      Session.create!(user: user) if Devise.sign_in_after_reset_password
      { user: user, errors: [] }
    else
      { errors: user.errors.full_messages }
    end
  end

  def validate_params(args)
    return { errors: ['Missing reset password token'] } if args[:password].present? && args[:reset_token].blank?
    return { errors: ['Missing password'] } if args[:password].blank? && args[:reset_token].present?
    return { errors: ['Missing email address'] } if args[:email].blank? && args[:reset_token].blank?

    nil
  end
end
