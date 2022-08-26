class Repository < ApplicationRecord
  belongs_to :user
  has_many :checks, class_name: 'RepositoryCheck', dependent: :destroy

  validates :full_name, presence: true, uniqueness: true

  extend Enumerize
  enumerize :language, in: %i[javascript ruby]
end
