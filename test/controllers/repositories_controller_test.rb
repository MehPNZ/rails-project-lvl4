# frozen_string_literal: true

require 'test_helper'
require_relative '../fixtures/files/response_repos'

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

    response = ResponseRepos::RESPONSE

    stub_request(:get, 'https://api.github.com/user/repos?per_page=100').with(headers: {
                                                                                'Accept' => 'application/vnd.github.v3+json',
                                                                                'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                                                                                'Authorization' => 'token qwertyuiopdsasdfghjklfszxcvbnmvd123456',
                                                                                'Content-Type' => 'application/json',
                                                                                'User-Agent' => 'Octokit Ruby Gem 4.23.0'
                                                                              }).to_return(status: 200, body: response, headers: {})

    get new_repository_url
    assert_response :success
  end

  test 'should get show' do
    sign_in(@user)
    get repository_url(@repository)
    assert_response :success
  end

  test 'should_create' do
    sign_in(@user)

    full_name = 'https://github.com/octocat/Hello-World'

    response = JSON.parse(load_fixture('response.json'))

    stub_request(:any, 'https://api.github.com/repos/octocat/Hello-World').to_return body: response.to_json, headers: { content_type: 'application/json' }

    post repositories_url, params: { repository: { full_name: full_name } }

    repository = Repository.find_by! full_name: full_name

    assert { repository }
    assert_redirected_to repositories_path
    assert_enqueued_with job: RepositoryLoaderJob
  end
end
