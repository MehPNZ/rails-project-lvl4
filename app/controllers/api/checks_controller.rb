# frozen_string_literal: true

class Api::ChecksController < ApplicationController
  protect_from_forgery with: :null_session
  # before_action :authenticate_user!

  def create
    return if params['head_commit'].nil?

    @repository = Repository.find_by(github_id: params['repository']['id'])
    @user = @repository.user
    sign_in(@user)
    authenticate_user!
    
    @check = @repository&.checks&.build(reference: params['head_commit']['url'])
    if @check.save
      RepositoryCheckJob.perform_later(@check.id)
      respond_to {|format| format.html}
    else
      render status: 500
    end
  end
end
