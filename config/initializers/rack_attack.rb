# frozen_string_literal: true

Rack::Attack.safelist('allow from localhost') do |req|
  req.ip == '127.0.0.1' && Rails.env.development?
end

Rack::Attack.throttle('logins/ip', limit: 20, period: 1.hour) do |req|
  req.ip if req.post? && req.path.start_with?('/users/sign_in')
end

ActiveSupport::Notifications.subscribe('rack.attack') do |_name, _start, _finish, _request_id, req|
  Rails.logger.info("Throttled #{req[:request].env['rack.attack.match_discriminator']}")
end
