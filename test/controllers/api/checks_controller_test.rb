# frozen_string_literal: true

require 'test_helper'

class Api::ChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @repository = repositories(:one)
    # @check = repository_checks(:one)
    @user = users(:one)
  end

  test 'should get create' do
    sign_in(@user)

    post api_checks_url, params: { repository: { id: @repository.github_id }, head_commit: { url: "https://test/test" }}

    check = Repository::Check.find_by! repository_id: @repository.id

    assert { check }
    assert_enqueued_with job: RepositoryCheckJob
  end
end
