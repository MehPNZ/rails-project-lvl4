# frozen_string_literal: true

class RepositoryService
  def self.update_repo_info(id, token, url_webhook)
    repository_loader = ApplicationContainer[:repository_loader]

    client = repository_loader.octokit_client(token)

    repository = Repository.find(id)

    params = repository_loader.get_repo(client, repository)

    repository.update(params)

    repository_loader.create_hook(client, repository.full_name, url_webhook)
  end
end
