class RepositoryLoaderStub

  def self.octokit_client(_)
  end

  def self.get_repo(_)
  end
  
  def self.create_hook(_)
  end

  def self.get_repos(client)
    ResponseRepos::RESPONSE
  end

end