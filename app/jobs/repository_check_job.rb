# frozen_string_literal: true

require 'json'

class RepositoryCheckJob < ApplicationJob
  include CheckJob
  queue_as :default

  def perform(id)
    check = Repository::Check.find(id)

    check_build(check)

    repository_check.repos_clear

    UserMailer.with(check: check).check_email.deliver_now unless check.passed
  rescue StandardError
    check&.to_fail! if check&.may_to_fail?
    UserMailer.with(check: check).check_email.deliver_now
    repository_check.repos_clear
  end

  private

  def check_build(check)
    check.to_check! if check.may_to_check?

    file = repository_check.lint_language(check)

    send("#{check.repository.language}_build", file, check)

    check.to_finish! if check.may_to_finish?
  end

  def repository_check
    ApplicationContainer[:repository_check]
  end
end
