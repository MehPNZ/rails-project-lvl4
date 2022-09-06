# frozen_string_literal: true

class RepositoryLoader < ApplicationRecord
  def self.octokit_client(token)
    Octokit::Client.new access_token: token, auto_paginate: true
  end

  def self.get_repo(client, repository)
    client.repo repository.full_name
  end

  def self.create_hook(client, repo, url_webhook)
    client.create_hook(repo.full_name, 'web', { url: url_webhook, content_type: 'json' }, { events: ['push'], active: true, insecure_ssl: 0 })
  end

  def self.get_repos(client)
    client.repos
  end

  def self.auth_omni(request)
    request
  end
end
