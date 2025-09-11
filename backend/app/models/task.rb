class Task < ApplicationRecord
  belongs_to :list
  validates :title, presence: true
  validates :position, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  has_many :task_assignments, dependent: :destroy
  has_many :assignees, through: :task_assignments, source: :user
end
