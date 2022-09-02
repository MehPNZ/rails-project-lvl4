# frozen_string_literal: true
class RepositoryLoader

  # def self.authenticate_user(session)
  #   redirect_to :back, notice: 'You need to log in' unless session[:user_id].nil?
  # end

  def self.octokit_client(token)
    Octokit::Client.new access_token: token, auto_paginate: true
  end

  def self.get_repo(client, repository)
    client.repo repository.full_name
  end

  def self.create_hook(client, repo)
    client.create_hook(repo.full_name, 'web', { url: ENV.fetch('BASE_URL', nil), content_type: 'json' }, { events: ['push'], active: true, insecure_ssl: 0 })
  end

  def self.get_repos(client)
    client.repos
  end

  def self.auth_omni(request)
    request
  end
end
