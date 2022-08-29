# frozen_string_literal: true

require 'json'

class RepositoryCheckJob < ApplicationJob
  include CheckJob
  queue_as :default

  def perform(id)
    Open3.capture2("rm -rf #{Rails.root}/tmp/repos/")

    check = RepositoryCheck.find(id)

    check.to_check! if check.may_to_check?

    file = lint_language(check)

    send("#{check.repository.language}_build", file, check)

    check.to_finish! if check.may_to_finish?
    Open3.capture2("rm -rf #{Rails.root}/tmp/repos/")

    if !check.passed || check.failed?
      UserMailer.with(check: check).check_email.deliver_now
    end
  rescue StandardError
    check.to_fail! if check.may_to_fail?
  end
end
