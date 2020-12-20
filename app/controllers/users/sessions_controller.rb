# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  prepend_before_action :already_authenticated?, only: :create
  prepend_before_action :verify_signed_out_user, only: :destroy

  # GET /resource/sign_in
  def new
    render json: { errors: [{ error: 'Not found' }] }, status: :not_found
  end

  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    render json: { result: { message: 'Success' } }, status: :ok
  end

  # DELETE /resource/sign_out
  def destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    self.resource = nil
    render json: { result: { message: 'Success' } }, status: :no_content
  end

  private

  def verify_signed_out_user
    render json: { result: { message: 'Success' } }, status: :no_content if all_signed_out?
  end

  def all_signed_out?
    users = Devise.mappings.keys.map { |s| warden.user(scope: s, run_callbacks: false) }

    users.all?(&:blank?)
  end

  def already_authenticated?
    render json: { result: { message: 'Success' } }, status: :ok if warden.authenticated?(resource_name)
  end

  def require_no_authentication; end
end
