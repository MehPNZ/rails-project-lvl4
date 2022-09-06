# frozen_string_literal: true

Rails.application.routes.default_url_options[:host] = ENV.fetch('BASE_URL', nil)

Rails.application.routes.draw do
  root to: 'home#index'

  scope module: :web do
    resources :users
    resource :session, only: :destroy

    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth

    resources :repositories do
      resources :checks, only: %i[show create]
    end
  end

  namespace :api do
    post 'checks', to: 'checks#create', as: :checks
  end
end
