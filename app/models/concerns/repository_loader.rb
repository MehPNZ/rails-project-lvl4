# frozen_string_literal: true

class RepositoryLoader < ApplicationRecord
  def self.octokit_client(token)
    Octokit::Client.new access_token: token, auto_paginate: true
  end

  def self.get_repo(client, repository)
    repo = client.repo repository.full_name
    {
      name: repo.name,
      github_id: repo.id,
      language: repo.language.downcase,
      repo_created_at: repo.created_at,
      repo_updated_at: repo.updated_at
    }
  end

  def self.create_hook(client, full_name, url_webhook)
    client.create_hook(full_name, 'web', { url: url_webhook, content_type: 'json' }, { events: ['push'], active: true, insecure_ssl: 0 })
  end

  def self.get_repos(client)
    client.repos
  end

  # def self.auth_omni(request)
  #   request
  # end

  def self.repo_job(repository, current_user, url_webhook)
    RepositoryLoaderJob.perform_later(repository.id, current_user.token, url_webhook)
  end
end
