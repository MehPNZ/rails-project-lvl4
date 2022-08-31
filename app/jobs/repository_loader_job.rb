# frozen_string_literal: true

class RepositoryLoaderJob < ApplicationJob
  queue_as :default

  def perform(id, token)
    debugger
    repository_loader = ApplicationContainer[:repository_loader]

    client = repository_loader.octokit_client(token)

    repository = Repository.find(id)

    repo = repository_loader.get_repo(client, repository)

    params = {
      name: repo.name,
      language: repo.language.downcase,
      repo_created_at: repo.created_at,
      repo_updated_at: repo.updated_at
    }

    repository.update(params)

    repository_loader.create_hook(client, repo)
  end
end
