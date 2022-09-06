# frozen_string_literal: true

require 'test_helper'

class Api::ChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @repository = repositories(:one)
    @user = users(:one)
  end

  test 'create' do
    payload = {
      repository: {
        id: @repository.github_id,
        full_name: @repository.full_name
      }
    }

    post api_checks_url, params: payload
    assert_response :ok

    check = @repository.checks.last

    assert { check.finished? }
    assert { check.passed }
  end
end
