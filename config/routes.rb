Rails.application.routes.draw do
  root to: "home#index"
  scope module: :web do
    resources :users

    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    resource :session, only: :destroy
  end
end
