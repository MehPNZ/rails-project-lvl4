require 'json'

class RepositoryCheckJob < ApplicationJob
  # include Sidekiq::Job
  include CheckJob
  queue_as :default

  def perform(id, email)
    Open3.capture2("rm -rf #{Rails.root}/tmp/repos/")
    
    check = Check.find(id)

    check.to_check! if check.may_to_check?

    file = lint_language(check)
    
    send("#{check.repository.language}_build", file, check)

    check.to_finish! if check.may_to_finish?
    Open3.capture2("rm -rf #{Rails.root}/tmp/repos/")
    # debugger
    # UserMailer.check_email(email).delivery_later unless check.check_passed
    UserMailer.with(email: email).check_email.deliver_now
    
  rescue StandardError
    check.to_fail! if check.may_to_fail?
  end

end
