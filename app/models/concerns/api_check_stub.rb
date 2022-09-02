class ApiCheckStub
  def self.check_commit(_)
    false
  end

  def self.repo_id(_)
   repos = Repository.new(language: 'ruby', full_name: 'MyString/MyString3', name: 'MyString3', user_id: 1, github_id: 123, repo_created_at: "11-11-2021",  repo_updated_at: "11-11-2021")
   repos.save
   repos
  end

  def self.build(repository, _)
    repository.checks.build(reference: "http://test")
  end

end 
