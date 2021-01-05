# frozen_string_literal: true

class GraphqlController < ApplicationController
  before_action :doorkeeper_authorize!, only: :execute
  before_action :user_authorized?, only: :execute
  # If accessing from outside this domain, nullify the session
  # This allows for outside API access while preventing CSRF attacks,
  # but you'll have to authenticate your user separately
  # protect_from_forgery with: :null_session

  def execute
    query = params[:query]
    operation_name = params[:operationName]
    context = {
      # Query context goes here, for example:
      # current_user: current_user,
    }
    result = IdpSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: result
  rescue StandardError => e
    render json: { errors: [{ error: e.message }] }, status: :bad_request
  end

  private

  # Handle variables in form data, JSON body, or a blank value
  # rubocop:disable Metrics/MethodLength
  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      # :nocov:
      variables_param
      # :nocov:
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    when nil
      {}
    else
      # :nocov:
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
      # :nocov:
    end
  end
  # rubocop:enable Metrics/MethodLength

  def user_authorized?
    return render json: { errors: [{ error: 'Unauthorized' }] }, status: :unauthorized if variables[:email].present? && variables[:email] != current_user.email

    render json: { errors: [{ error: 'Unauthorized' }] }, status: :unauthorized if variables[:id] && variables[:id] != current_user.id
  end

  def variables
    @variables ||= prepare_variables(params[:variables])
  end
end
