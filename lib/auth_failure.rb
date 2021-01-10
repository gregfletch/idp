# frozen_string_literal: true

class AuthFailure < Devise::FailureApp
  def respond
    if request.env.dig('warden.options', :action) == :unauthenticated &&
       %i[invalid unconfirmed not_found_in_database].include?(request.env.dig('warden.options', :message))
      error_response(request.env.dig('warden.options', :message))
    else
      error_response('General login failure')
    end
  end

  private

  def error_response(error_message)
    self.status = 401
    self.content_type = 'json'
    self.response_body = {
      errors: [
        error: error_message
      ]
    }.to_json
  end
end
