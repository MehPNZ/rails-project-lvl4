require 'octokit'

class RepositoryLoaderJob < ApplicationJob
  queue_as :default

  def perform(id, token)
    client = Octokit::Client.new access_token: token, auto_paginate: true
    repository = Repository.find(id)

    repo = client.repo repository.full_name

    params = {
      name: repo.name,
      language: repo.language.downcase,
      repo_created_at: repo.created_at,
      repo_updated_at: repo.updated_at
    }

    repository.update(params)

    client.create_hook(repo.full_name, 'web', { url: ENV.fetch('BASE_URL', nil), content_type: 'json' }, { events: ['push'], active: true, insecure_ssl: 0 })
  end
end
