# frozen_string_literal: true

class Web::RepositoriesController < Web::ApplicationController
  before_action :authenticate_user!

  def index
    @repositories = Repository.where(user_id: current_user.id)
  end

  def new
    @repository = current_user&.repositories&.new
    repos_names
  end

  def create
    @repository = current_user.repositories.build(permitted_params)

    if @repository.save
      url_webhook = url_for(controller: 'api/checks', action: 'create')
      repository_loader.repo_job(@repository, current_user, url_webhook)

      redirect_to repositories_path, notice: t('repo_created')
    else
      repos_names
      flash[:notice] = @repository.errors.full_messages.to_sentence
      render :new, locals: { repos: @repos }, status: :found
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
    client = repository_loader.octokit_client(current_user.token)
    @repos = Rails.cache.fetch('repos_name', expires_in: 12.hours) do
      repository_loader.get_repos(client).each_with_object([]) do |item, array|
        array << [item[:full_name], item[:id]] if language_list.include?(item[:language]&.downcase)
      end
    end
  rescue Octokit::Unauthorized
    redirect_to root_path, notice: t('repo_token')
  end

  def permitted_params
    params.require(:repository).permit(:github_id)
  end

  def repository_loader
    ApplicationContainer[:repository_loader]
  end
end
