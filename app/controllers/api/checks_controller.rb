# frozen_string_literal: true

class Api::ChecksController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    return if params['head_commit'].nil?

    @repository = Repository.find_by(full_name: params['repository']['full_name'])
    @check = @repository&.checks&.build(reference: params['head_commit']['url'])
    if @check.save
      RepositoryCheckJob.perform_later(@check.id)
      render status: 200,  json: @check.to_json
    else
      render status: 500
    end
  end
end
