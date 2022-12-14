# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'webmock/minitest'

OmniAuth.config.test_mode = true

class ActiveSupport::TestCase
  parallelize(workers: :number_of_processors)

  def load_fixture(filename)
    File.read(File.dirname(__FILE__) + "/fixtures/files/#{filename}")
  end

  fixtures :all
end

class ActionDispatch::IntegrationTest
  def sign_in(_user, _options = {})
    auth_hash = Faker::Omniauth.github
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)
    get callback_auth_path('github')
  end

  def signed_in?
    session[:user_id].present? && current_user.present?
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
