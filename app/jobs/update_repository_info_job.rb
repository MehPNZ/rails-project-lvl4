# frozen_string_literal: true

class UpdateRepositoryInfoJob < ApplicationJob
  queue_as :default

  def perform(id, token, url_webhook)
    RepositoryService.update_repo_info(id, token, url_webhook)
  end
end
