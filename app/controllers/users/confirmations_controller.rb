# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation/new
  def new
    render json: { errors: [{ error: 'Not found' }] }, status: :not_found
  end

  # POST /resource/confirmation
  def create
    render json: { errors: [{ error: 'Not found' }] }, status: :not_found
  end

  # GET /users/confirmation?confirmation_token=abcdef
  def show
    self.resource = resource_class.confirm_by_token(confirmation_params[:confirmation_token])
    return render json: { result: { message: 'Success', user: resource } }, status: :ok if resource.errors.blank?

    handle_error_response_show(resource)
  end

  private

  def confirmation_params
    params.permit(:confirmation_token)
  end

  def handle_error_response_show(resource)
    render json: { errors: resource.errors.errors.each.to_h { |e| [e.attribute, e.type] } }, status: :bad_request
  end
end
