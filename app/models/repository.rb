class Repository < ApplicationRecord
  belongs_to :user
  has_many :checks, dependent: :destroy

  validates :full_name, presence: true, uniqueness: true

  extend Enumerize
  enumerize :language, in: %i[javascript ruby]
end
