# README

This is a simple identity provider (IdP) service. In this README you will find instructions to setup a Ruby environment, install dependencies, run the server, and run the tests.

### Installing Ruby

Install the latest version of Ruby with brew - `brew install ruby`. Once Ruby is installed (this may take a while as it has to build native binaries), install bundler so that you can install Ruby dependencies - `gem install bundler`.

### Installing Dependencies

Install the dependencies for this service by running `bundle install`. After installing the dependencies, you may wish to add the Rubocop git pre-commit hook by running `rake rubocop:install`.

### Database Creation/Initialization

To create the database, run `rails db:setup` and to initialize the database and apply the current schema, run `rails db:migrate`.

### Test

To run the test suite, simply run `rspec`. If you wish to run the test suite with code coverage enabled, run `COVERAGE=true rspec`. Alternatively, you can export `COVERAGE=true` as an environment variable in your `~/.zshrc` file to always run the test suite with coverage.

### Running the Service

To run the IdP service, run `rails s`.
