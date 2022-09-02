# frozen_string_literal: true

require 'test_helper'

class Web::AuthControllerTest < ActionDispatch::IntegrationTest
  # test 'check github auth' do
  #   post auth_request_path('github')
  #   assert_response :redirect
  # end

  # test 'create' do
  #    auth_hash =Faker::Omniauth.github 
    
  #   OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(auth_hash)
  #   get callback_auth_path('github')

  #   assert_response :redirect

  #   user = User.find_by!(email: auth_hash[:info][:email].downcase)

  #   assert user
  #   assert signed_in?
  # end
end
