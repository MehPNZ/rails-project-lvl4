# frozen_string_literal: true

module AuthConcern
  extend ActiveSupport::Concern

  def sign_in(user)
    session[:user_id] = user.id
  end

  def sign_out
    session.delete(:user_id)
    session.clear
  end

  def user_signed_in?
    !current_user.nil?
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def authenticate_user!
    unless user_signed_in? 
      redirect_to callback_auth_path('github')
    end
  end
end
