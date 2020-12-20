# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  # devise_for :users, skip: [:registrations]

  # devise_scope :user do
  #   post 'sign_up', to: 'users/registrations#create', as: :user_registration
  # end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
