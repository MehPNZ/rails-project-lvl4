# frozen_string_literal: true

class UpdateRepositoryInfoJob < ApplicationJob
  include RepositoryService
  queue_as :default

  def perform(id, token, url_webhook)
    update_repo_info(id, token, url_webhook)
  end
end
