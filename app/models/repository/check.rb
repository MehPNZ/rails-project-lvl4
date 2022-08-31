# frozen_string_literal: true

class Repository::Check < ApplicationRecord
  belongs_to :repository

  include AASM

  aasm do
    state :created, initial: true
    state :checking
    state :finished
    state :failed

    event :to_check do
      transitions from: :created, to: :checking
    end

    event :to_finish do
      transitions from: :checking, to: :finished
    end

    event :to_fail do
      transitions to: :failed
    end
  end
end
