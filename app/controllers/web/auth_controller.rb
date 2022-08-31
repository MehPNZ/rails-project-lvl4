# frozen_string_literal: true

class Web::AuthController < Web::ApplicationController
  def callback
    
    email = auth[:info][:email].downcase
    nickname = auth[:info][:nickname]
    token = auth[:credentials][:token]
    
    existing_user = User.find_or_create_by(email: email) do |user|
      user.nickname = nickname
    end

    existing_user.update(token: token)

    if existing_user

      sign_in existing_user
      redirect_to root_path, notice: 'Successfully signed in into your account'
    else
      redirect_to root_path, notice: 'Error auth!'
    end
  end

  private

  def auth
    auth = ApplicationContainer[:auth]
    auth.request_omniauth(request.env['omniauth.auth'])
  end
end
