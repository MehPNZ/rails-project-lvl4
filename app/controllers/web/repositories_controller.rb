# frozen_string_literal: true

class Web::RepositoriesController < Web::ApplicationController
  before_action :authenticate_user!
  # protect_from_forgery with: :null_session
  after_action :verify_authorized, except: %i[index]

  def index
    @repositories ||= Repository.where(user_id: current_user.id)
  end

  def new
    @repository = current_user&.repositories&.new
    authorize @repository
    repos_names
  end

  def create
    @repository = current_user.repositories.build(permitted_params)
    authorize @repository

    if @repository.save
      RepositoryLoaderJob.perform_later(@repository.id, current_user.token)
      redirect_to repositories_path, notice: 'Repository is created.'
    else
      repos_names
      flash[:notice] = @repository.errors.full_messages.to_sentence
      render :new, locals: { repos: @repos }, status: :unprocessable_entity
      flash.clear
    end
  end

  def show
    @repository = Repository.find params[:id]
    authorize @repository
    @checks = @repository.checks.order(created_at: :desc)
  end

  private

  def repos_names
    language_list = Repository.language.values
    client = Octokit::Client.new access_token: current_user.token, auto_paginate: true
    @repos ||= client.repos.each_with_object([]) do |item, array|
      array << item[:full_name] if language_list.include?(item[:language]&.downcase)
    end
  rescue Octokit::Unauthorized
    redirect_to root_path, notice: 'Your token has expired. Please re-login'
  end

  def permitted_params
    params.require(:repository).permit(:full_name)
  end
end
