Rails.application.routes.draw do

  root to: 'home#index'
  
  scope module: :web do
    resources :users
    resource :session, only: :destroy
    resources :repositories do
      resources :checks, only: %i[show create]
    end
  end

  scope module: :api do
    scope module: :checks do
      post 'auth/:provider', to: 'auth#request', as: :auth_request
      get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    end
  end

  namespace :api do
    post 'checks', to: 'checks#create', as: :checks
  end
end
