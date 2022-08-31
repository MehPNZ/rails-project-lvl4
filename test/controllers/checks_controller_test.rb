# frozen_string_literal: true

require 'test_helper'

class ChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @repository = repositories(:one)
    @check = repository_checks(:one)
    @user = users(:one)
  end

  test 'should get create' do
    sign_in(@user)

    post repository_checks_url(@repository)

    check = Repository::Check.find_by! repository_id: @repository.id

    assert { check }
    assert_redirected_to repository_path(@repository)
    assert_enqueued_with job: RepositoryCheckJob
  end

  test 'should get show' do
    get repository_check_path(@repository.id, @check.id)
    assert_response :found
  end
end
