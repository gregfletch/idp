# frozen_string_literal: true

# Store the user with the login activity on failure (if the user exists)
AuthTrail.transform_method = lambda do |data, _request|
  data[:user] ||= User.find_by(email: data[:identity])
end
