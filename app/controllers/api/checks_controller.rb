# frozen_string_literal: true

class Api::ChecksController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    return if params['head_commit'].nil?

    @repository = Repository.find_by(full_name: params['repository']['full_name'])
    @check = @repository&.checks&.build(reference: params['head_commit']['url'])
    @check.save
    RepositoryCheckJob.perform_later(@check.id)
      # redirect_to repository_path(@repository), notice: 'Check created!', status: 200
    # else
      # redirect_to repository_path(@repository), notice: 'ERROR: Check not created!', status: 200
    # end
  end
end
