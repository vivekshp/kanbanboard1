class List < ApplicationRecord
  belongs_to :board

  validates :title, presence: true
  validates :limit, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
