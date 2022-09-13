# frozen_string_literal: true

class RepositoryLoaderStub
  def self.octokit_client(token)
    User.find_by(token: token)
  end

  def self.get_repo(_client, _repository)
    {
      full_name: 'Hello!',
      name: 'First',
      language: 'ruby',
      repo_created_at: '11-11-2021',
      repo_updated_at: '11-11-2021'
    }
  end

  def self.create_hook(client, full_name, url_webhook); end

  def self.get_repos(_client)
    [{ full_name: 'MehPNZ/ruby-gems', language: 'Ruby' }]
  end

  def self.repo_job(repository, current_user, url_webhook)
    UpdateRepositoryInfoJob.perform_now(repository.id, current_user.token, url_webhook)
  end
end
