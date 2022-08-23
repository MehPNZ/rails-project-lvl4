# frozen_string_literal: true

class RepositoryPolicy < ApplicationPolicy
  def index?
    @record.empty? ? true : @record.last.user_id == user&.id
  end

  def show?
    @record&.user_id == user&.id
  end

  def create?
    @record&.user_id == user&.id
  end

  def new?
    @record&.user_id == user&.id
  end

end