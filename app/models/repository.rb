# frozen_string_literal: true

class Repository < ApplicationRecord
  belongs_to :user
  has_many :checks, class_name: 'Repository::Check', dependent: :destroy

  validates :github_id, presence: true, uniqueness: true

  extend Enumerize
  enumerize :language, in: %i[javascript ruby]
end
