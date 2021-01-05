# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::MimeResponds

  respond_to :json

  def current_resource_owner
    # :nocov:
    @current_user ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    # :nocov:
  end

  def current_user
    current_resource_owner
  end
end
