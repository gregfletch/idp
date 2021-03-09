# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  prepend_before_action :already_authenticated?, only: :create
  prepend_before_action :doorkeeper_authorize!, only: :destroy

  # GET /users/sign_in
  def new
    render json: { errors: [{ error: 'Not found' }] }, status: :not_found
  end

  # POST /users/sign_in
  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    session = Session.create!(user: resource)
    render json: { result: { message: 'Success', user: { id: resource.id, session_id: session.id } } }, status: :ok
  end

  # DELETE /users/sign_out
  def destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    application_ids = Doorkeeper::Application.pluck(:id)
    Doorkeeper::AccessToken.revoke_all_for(application_ids, current_user.id)
    @current_user = nil
    self.resource = nil
    render json: { result: { message: 'Success' } }, status: :no_content
  end

  private

  def verify_signed_out_user; end

  def all_signed_out?; end

  def already_authenticated?
    render json: { result: { message: 'Success' } }, status: :ok if warden.authenticated?(resource_name)
  end

  def require_no_authentication; end
end
