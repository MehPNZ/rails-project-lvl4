# frozen_string_literal: true

class Web::AuthController < Web::ApplicationController
  def callback
    if github_user(auth)
      sign_in github_user(auth)
      redirect_to root_path, notice: t('auth_signed')
    else
      redirect_to root_path, notice: t('auth_error')
    end
  end

  private

  def auth
    request.env['omniauth.auth']
  end
end
