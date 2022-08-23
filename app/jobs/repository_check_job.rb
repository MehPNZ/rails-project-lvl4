require 'json'

class RepositoryCheckJob < ApplicationJob
  # include Sidekiq::Job
  include CheckJob
  queue_as :default

  def perform(id)
    Open3.capture2("rm -rf #{Rails.root}/tmp/repos/")
    
    check = Check.find(id)

    check.to_check! if check.may_to_check?

    file = lint_language(check)
    
    file.inspect
    sleep 15
    send("#{check.repository.language}_build", file, check)

    check.to_finish! if check.may_to_finish?
    Open3.capture2("rm -rf #{Rails.root}/tmp/repos/")

  rescue StandardError
    check.to_fail! if check.may_to_fail?
  end

end
