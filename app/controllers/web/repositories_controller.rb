# frozen_string_literal: true

class Web::RepositoriesController < Web::ApplicationController
  before_action :authenticate_user!

  def index
    @repositories ||= Repository.where(user_id: current_user.id)
  end

  def new
    @repository = current_user&.repositories&.new
    repos_names
  end

  def create
    @repository = current_user.repositories.build(permitted_params)
    if @repository.save
      RepositoryLoaderJob.perform_later(@repository.id, current_user.token)
      redirect_to repository_path(@repository), notice: 'Repository is created.'
    else
      repos_names
      flash[:notice] = @repository.errors.full_messages.to_sentence
      render :new, locals: { repos: @repos }, status: 302
      flash.clear
    end
  end

  def show
    @repository = Repository.find params[:id]
    @checks = @repository.checks.order(created_at: :desc)
  end

  private

  def repos_names
    language_list = Repository.language.values
    repository_loader = ApplicationContainer[:repository_loader]
    client = repository_loader.octokit_client(current_user.token)
    @repos ||= repository_loader.get_repos(client).each_with_object([]) do |item, array|
      array << item[:full_name] if language_list.include?(item[:language]&.downcase)
    end
  rescue Octokit::Unauthorized
    redirect_to root_path, notice: 'Your token has expired. Please re-login'
  end

  def permitted_params
    params.require(:repository).permit(:full_name)
  end
end
