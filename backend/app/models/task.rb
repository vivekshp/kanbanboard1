class Task < ApplicationRecord
  belongs_to :list
  validates :title, presence: true
  validates :position, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
end
