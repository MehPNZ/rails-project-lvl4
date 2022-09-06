# frozen_string_literal: true

class ApiCheckStub
  def self.check_commit(_)
    false
  end

  def self.build(repository, _)
    repository.checks.build(reference: 'http://test')
  end
end
