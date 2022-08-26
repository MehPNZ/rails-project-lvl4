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

  scope module: :api do
    # scope module: :checks do
    #   post 'auth/:provider', to: 'auth#request', as: :auth_request
    #   get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    # end
    post 'checks', to: 'checks#create', as: :api_checks
  end
end
