# frozen_string_literal: true

require 'test_helper'

class RepositoriesControllerTest < ActionDispatch::IntegrationTest
  # setup do
  #   @repository = repositories(:one)
  #   @user = users(:one)
  # end

  # test 'should get index' do
  #   sign_in(@user)
  #   get repositories_url
  #   assert_response :success
  # end

  # test 'should get new' do
  #   sign_in(@user)

  #   get new_repository_url
  #   assert_response :success
  # end

  # test 'should get show' do
  #   get repository_url(@repository)
  #   assert_response :found
  # end

  # test 'should_create' do
  #   sign_in(@user)

  #   full_name = 'https://github.com/octocat/Hello-World'

  #   response = JSON.parse(load_fixture('response.json'))

  #   stub_request(:any, 'https://api.github.com/repos/octocat/Hello-World').to_return body: response.to_json, headers: { content_type: 'application/json' }

  #   post repositories_url, params: { repository: { full_name: full_name } }

  #   repository = Repository.find_by! full_name: full_name

  #   assert { repository }
  #   assert_redirected_to repository_path(repository)
  #   assert_enqueued_with job: RepositoryLoaderJob
  # end
end
