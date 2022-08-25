require 'open3'

class Web::ChecksController < Web::ApplicationController
  after_action :verify_authorized
  def create
    @repository = Repository.find(params[:repository_id])
    authorize @repository

    @check = @repository.checks.build(permitted_params)
    if @check.save

      # UserMailer.with(user: current_user).check_email.deliver_now

      RepositoryCheckJob.perform_later(@check.id, current_user.email)
      redirect_to repository_path(@repository), notice: 'Check created!'
    else
      redirect_to repository_path(@repository), notice: 'ERROR: Check not created!'
    end
  end

  def show
    @repository = Repository.find(params[:repository_id])
    authorize @repository
    @check ||= Check.find(params[:id])
    @report ||= ActiveSupport::JSON.decode(@check.report)
  end

  private

  def permitted_params
    params.permit(:repository_id)
  end
end
