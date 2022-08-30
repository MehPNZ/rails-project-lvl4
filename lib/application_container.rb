# frozen_string_literal: true

require 'dry-container'

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register :repository_loader, -> { RepositoryLoaderStub }
  else
    register :repository_loader, -> { RepositoryLoader }
  end
end
