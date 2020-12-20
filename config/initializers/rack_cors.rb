# frozen_string_literal: true

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'localhost:4200', 'app.lvh.me:4200', 'app.local:4200'
    resource '/users', headers: :any, methods: %i[post options]
    resource '/users/confirmation', headers: :any, methods: %i[get options]
  end
end
