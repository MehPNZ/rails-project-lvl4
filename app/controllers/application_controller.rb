# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include AuthConcern
  include GithubService
end
