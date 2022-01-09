# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'
# Use postgresql as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'authtrail'

gem 'batch-loader', git: 'https://github.com/gregfletch/batch-loader'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap'

gem 'bundler-audit'

gem 'devise'
gem 'devise-two-factor'
gem 'doorkeeper'
gem 'doorkeeper-jwt'

gem 'geocoder'

gem 'graphql'

gem 'json-jwt'

gem 'logstop'

gem 'maxminddb'

gem 'rack-attack'

gem 'rack-cors'

group :development, :test do
  gem 'brakeman'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'rubocop'
  gem 'rubocop-graphql'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'rubocop_runner'
end

group :development do
  gem 'letter_opener'
  gem 'letter_opener_web'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'listen'
  gem 'rack-mini-profiler'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console'
end

group :test do
  gem 'codecov'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'simplecov'
end
