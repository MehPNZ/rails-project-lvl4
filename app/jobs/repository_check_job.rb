# frozen_string_literal: true

require 'json'

class RepositoryCheckJob < ApplicationJob
  include CheckJob
  queue_as :default

  def perform(id)
    
    repository_check = ApplicationContainer[:repository_check]
    
    repository_check.repos_clear

    check = Repository::Check.find(id)

    check.to_check! if check.may_to_check?

    file = repository_check.lint_language(check)

    send("#{check.repository.language}_build", file, check)

    check.to_finish! if check.may_to_finish?

    repository_check.repos_clear

    if !check.passed || check.failed?
      UserMailer.with(check: check).check_email.deliver_now
    end
  rescue StandardError
    check&.to_fail! if check&.may_to_fail?
  end
end
