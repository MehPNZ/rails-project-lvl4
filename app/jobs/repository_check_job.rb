# frozen_string_literal: true

require 'json'

class RepositoryCheckJob < ApplicationJob
  include CheckJob
  queue_as :default

  def perform(id)
    check = Repository::Check.find(id)

    repo_check(check)
  end
end
