# frozen_string_literal: true

class Api::ChecksController < ApplicationController
  # protect_from_forgery with: :null_session
  # before_action :authenticate_user!

  def create
    api_check = ApplicationContainer[:api_check]
    # return if params['head_commit'].nil?
    return if api_check.check_commit(params)

    repository = Repository.find_by(github_id: params['repository']['id'])
    # repository = api_check.repo_id(params)

    # @user = @repository.user
    # sign_in(@user)
    # authenticate_user!

    # @check = @repository.checks.build(reference: params['head_commit']['url'])
    check = api_check.build(repository, params)

    if check.save
      repository_check = ApplicationContainer[:repository_check]
      repository_check.check_job(check)
      # RepositoryCheckJob.perform_later(check.id)
      # respond_to {|format| format.html}
    else
      render status: :internal_server_error
    end
  end
end
