# frozen_string_literal: true

Rails.application.routes.draw do
  use_doorkeeper

  post '/graphql', to: 'graphql#execute'

  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  # :nocov:
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  # :nocov:
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
