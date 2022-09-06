# frozen_string_literal: true

require 'test_helper'

class ChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @repository = repositories(:one)
    @check = repository_checks(:one)
    @user = users(:one)
  end

  test 'should get show' do
    sign_in(@user)
    get repository_check_url(@repository.id, @check.id)
    assert_response :success
  end

  test 'create' do
    sign_in(@user)

    post repository_checks_url(@repository)
    assert_response :redirect

    check = @repository.checks.last
    
    assert { check.finished? }
    assert { check.passed }
  end
end
