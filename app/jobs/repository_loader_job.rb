# frozen_string_literal: true

class RepositoryLoaderJob < ApplicationJob
  queue_as :default

  def perform(id, token, url_webhook)
    repository_loader = ApplicationContainer[:repository_loader]

    client = repository_loader.octokit_client(token)

    repository = Repository.find(id)

    repo = repository_loader.get_repo(client, repository)
    params = {
      name: repo.name,
      github_id: repo.id,
      language: repo.language.downcase,
      repo_created_at: repo.created_at,
      repo_updated_at: repo.updated_at
    }

    repository.update(params)
    # client.create_hook(repo.full_name, 'web', { url: url_webhook, content_type: 'json' }, { events: ['push'], active: true, insecure_ssl: 0 })
    repository_loader.create_hook(client, repo, url_webhook)
  end
end
