class Repository < ApplicationRecord
  belongs_to :user
  has_many :checks, dependent: :destroy

  validates :link, presence: true, uniqueness: true

  extend Enumerize
  enumerize :language, in: %i[javascript ruby]
end
