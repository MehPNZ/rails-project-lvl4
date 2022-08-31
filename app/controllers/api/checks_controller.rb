# frozen_string_literal: true

class Api::ChecksController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    return if params['head_commit'].nil?

    @repository = Repository.find_by(full_name: params['repository']['full_name'])
    @check = @repository&.checks&.build(reference: params['head_commit']['url'])
    if @check.save
      RepositoryCheckJob.perform_later(@check.id)
      redirect_to repository_path(@repository), notice: 'Check created!'
    else
      redirect_to repository_path(@repository), notice: 'ERROR: Check not created!'
    end
  end
end
