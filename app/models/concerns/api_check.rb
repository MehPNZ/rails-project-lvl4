class ApiCheck
  def check_commit
    params['head_commit'].nil?
  end

  # def self.repo_id(params)
  #   params['repository']['id']
  # end
end