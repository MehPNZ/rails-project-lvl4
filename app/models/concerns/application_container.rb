# frozen_string_literal: true

require 'dry-container'
require 'octokit'

module ApplicationContainer
  extend Dry::Container::Mixin
  extend ActiveSupport::Concern

  if Rails.env.test?
    register :api_check, -> { ApiCheckStub }
    register :repository_loader, -> { RepositoryLoaderStub }
    register :repository_check, -> { RepositoryCreateCheckStub }
    register :auth, -> { AuthOmniStub }
  else
    register :api_check, -> { ApiCheck }
    register :repository_loader, -> { RepositoryLoader }
    register :repository_check, -> { RepositoryCreateCheck }
    register :auth, -> { AuthOmni }
  end
end
