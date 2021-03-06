[![codecov](https://codecov.io/gh/gregfletch/idp/branch/main/graph/badge.svg?token=JKHA695S5K)](https://codecov.io/gh/gregfletch/idp) ![Build](https://github.com/gregfletch/idp/workflows/Ruby/badge.svg) [![Maintainability](https://api.codeclimate.com/v1/badges/9ed347443e451f37da8b/maintainability)](https://codeclimate.com/github/gregfletch/idp/maintainability) [![Ruby Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop-hq/rubocop)

# README

This is a simple identity provider (IdP) service. In this README you will find instructions to setup a Ruby environment, install dependencies, run the server, and run the tests.

### Installing Ruby

Install the latest version of Ruby and chruby to manage Ruby versions with brew - `brew install chruby ruby-install`. Once this is completed, use ruby-install to install the latest version of Ruby (`ruby-install`) and use chruby to select this version of Ruby on completion. Once Ruby is installed (this may take a while as it has to build native binaries), install bundler so that you can install Ruby dependencies - `gem install bundler`.

### Installing Dependencies

Install the dependencies for this service by running `bundle install`. After installing the dependencies, you may wish to add the Rubocop git pre-commit hook by running `rake rubocop:install`.

### Database Creation/Initialization

To create the database, run `rails db:setup` and to initialize the database and apply the current schema, run `rails db:migrate`.

### Test

To run the test suite, simply run `rspec`. If you wish to run the test suite with code coverage enabled, run `COVERAGE=true rspec`. Alternatively, you can export `COVERAGE=true` as an environment variable in your `~/.zshrc` file to always run the test suite with coverage.

### Running the Service

To run the IdP service, run `rails s`.
