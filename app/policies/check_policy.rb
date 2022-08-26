# frozen_string_literal: true

class RepositoryCheckPolicy < ApplicationPolicy
  
  def show?
    @record&.user_id == user&.id
  end

  def create?
    @record&.user_id == user&.id
  end

end
