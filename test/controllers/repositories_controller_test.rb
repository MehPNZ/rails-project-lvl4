# frozen_string_literal: true

require 'test_helper'

class RepositoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @repository = repositories(:one)
    @user = users(:one)
  end

  test 'should get index' do
    sign_in(@user)
    get repositories_url
    assert_response :success
  end

  test 'should get new' do
    sign_in(@user)

    get new_repository_url
    assert_response :success
  end

  test 'should get show' do
    sign_in(@user)
    get repository_url(@repository)
    assert_response :success
  end

  test 'create' do
    sign_in(@user)
    id = Faker::Number.number(digits: 10)

    attrs = {
      github_id: id
    }

    post repositories_url, params: {
      repository: attrs
    }

    assert_response :redirect

    repository = Repository.find_by github_id: id

    assert { repository }

    assert { repository.language.present? }
    assert { repository.full_name.present? }
  end
end
