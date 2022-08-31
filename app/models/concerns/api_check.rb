class ApiCheck
  def self.check_commit(params)
    params['head_commit'].nil?
  end

  def self.repo_id(params)
    Repository.find_by(github_id: params['repository']['id'])
  end

  def self.build(repository, params)
    repository.checks.build(reference: params['head_commit']['url'])
  end

end 