# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: :create
  before_action :validate_sign_up_params, only: :create

  # GET /resource/sign_up
  def new
    render json: { errors: [{ error: 'Not found' }] }, status: :not_found
  end

  # POST /users
  def create
    build_resource(sign_up_params)

    resource.save
    if resource.persisted?
      expire_data_after_sign_in!
      render json: { result: { message: 'Success', user: resource } }, status: :created
    else
      handle_error_response_create(resource)
    end
  end

  # GET /resource/edit
  def edit
    render json: { errors: [{ error: 'Not found' }] }, status: :not_found
  end

  # PUT /resource
  def update
    render json: { errors: [{ error: 'Not found' }] }, status: :not_found
  end

  # DELETE /resource
  def destroy
    render json: { errors: [{ error: 'Not found' }] }, status: :not_found
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    render json: { errors: [{ error: 'Not found' }] }, status: :not_found
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name username])
  end

  private

  # rubocop:disable Metrics/AbcSize
  def validate_sign_up_params
    errors = []
    errors << { error: 'Email is missing' } if params.dig(:user, :email).blank?
    errors << { error: 'Password is missing' } if params.dig(:user, :password).blank?
    errors << { error: 'First name is missing' } if params.dig(:user, :first_name).blank?
    errors << { error: 'Last name is missing' } if params.dig(:user, :last_name).blank?

    render json: { errors: errors }, status: :bad_request if errors.present?
  end
  # rubocop:enable Metrics/AbcSize

  def handle_error_response_create(resource)
    render json: { errors: [resource.errors.errors.each.map { |e| ['error', e.full_message] }.to_h] }, status: :bad_request
  end

  # Override super class method to prevent errors if a user hits an endpoint that we have not implemented/are not
  # supporting
  def authenticate_scope!; end
end
