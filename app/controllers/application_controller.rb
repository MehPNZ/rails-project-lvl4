class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include AuthConcern
end
