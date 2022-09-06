# frozen_string_literal: true

class Repository < ApplicationRecord
  belongs_to :user
  # has_many :checks, class_name: 'RepositoryCheck', dependent: :destroy
  has_many :checks, class_name: 'Repository::Check', dependent: :destroy

  # validates :full_name, presence: true

  extend Enumerize
  enumerize :language, in: %i[javascript ruby]
end
