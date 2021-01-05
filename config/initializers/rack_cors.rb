# frozen_string_literal: true

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'graphql.app.lvh.me:4200'
    resource '/graphql', headers: :any, methods: %i[post options]
    resource '/oauth/revoke', headers: :any, methods: %i[post options]
    resource '/oauth/token', headers: :any, methods: %i[post options]
    resource '/users', headers: :any, methods: %i[post options]
    resource '/users/confirmation', headers: :any, methods: %i[get options]
    resource '/users/sign_in', headers: :any, methods: %i[post options]
    resource '/users/sign_out', headers: :any, methods: %i[delete options]
  end
end
