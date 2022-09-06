# frozen_string_literal: true

class Api::ChecksController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    api_check = ApplicationContainer[:api_check]
    return if api_check.check_commit(params)

    repository = Repository.find_by(github_id: params['repository']['id'])

    check = api_check.build(repository, params)

    if check.save
      repository_check = ApplicationContainer[:repository_check]
      repository_check.check_job(check)
    else
      render status: :internal_server_error
    end
  end
end
