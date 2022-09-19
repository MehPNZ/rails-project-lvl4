# frozen_string_literal: true

class Web::AuthController < Web::ApplicationController
  def callback
    if sign_in login_via_github!(auth)
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
