
require "dry-container"
require 'octokit'

module ApplicationContainer
  extend Dry::Container::Mixin
  extend ActiveSupport::Concern
  
  if Rails.env.test?
    register :repository_loader, -> { RepositoryLoaderStub }
    register :repository_check, -> { RepositoryCreateCheckStub }
    register :auth, -> { AuthOmniStub }
  else
    register :repository_loader, -> { RepositoryLoader }
    register :repository_check, -> { RepositoryCreateCheck }
    register :auth, -> { AuthOmni }
  end

end