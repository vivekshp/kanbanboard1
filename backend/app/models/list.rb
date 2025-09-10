class List < ApplicationRecord
  belongs_to :board
  has_many :tasks, dependent: :destroy

  validates :title, presence: true
  validates :position, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :limit, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
end
