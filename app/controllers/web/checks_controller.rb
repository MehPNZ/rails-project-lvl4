# frozen_string_literal: true

require 'open3'

class Web::ChecksController < Web::ApplicationController
  before_action :authenticate_user!
  caches_action :show

  def create
    @repository = Repository.find(params[:repository_id])

    @check = @repository.checks.build(permitted_params)
    if @check.save
      repository_check.check_job(@check)
      redirect_to repository_path(@repository), notice: t('check_created')
    else
      redirect_to repository_path(@repository), notice: t('check_error')
    end
  end

  def show
    @repository = Repository.find(params[:repository_id])
    @check ||= Repository::Check.find(params[:id])
    @report = repository_check.show(@check)
  end

  private

  def permitted_params
    params.permit(:repository_id)
  end

  def repository_check
    ApplicationContainer[:repository_check]
  end
end
