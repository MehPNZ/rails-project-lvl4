require 'sidekiq/web'

Rails.application.routes.draw do
  root to: 'home#index'
  scope module: :web do
    resources :users

    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    resource :session, only: :destroy
    resources :repositories do
      resources :checks, only: %i[show create]
    end
  end

  namespace :api do

    post 'checks', to: 'checks#create'
    # resource :checks, only: :create, defaults: { formats: :json }
  end

  mount Sidekiq::Web => '/sidekiq'
end
