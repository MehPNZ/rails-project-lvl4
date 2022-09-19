# frozen_string_literal: true

require 'dry-container'
require 'octokit'

module ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register :api_check, -> { ApiCheckStub }
    register :repository_loader, -> { RepositoryLoaderStub }
    register :repository_check, -> { RepositoryCreateCheckStub }
  else
    register :api_check, -> { ApiCheck }
    register :repository_loader, -> { RepositoryLoader }
    register :repository_check, -> { RepositoryCreateCheck }
  end
end
