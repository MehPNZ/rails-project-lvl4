# frozen_string_literal: true

class ApiCheck
  def self.check_commit(params)
    params['head_commit'].nil?
  end

  def self.build(repository, params)
    repository.checks.build(reference: params['head_commit']['url'])
  end
end
