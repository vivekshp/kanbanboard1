class Board < ApplicationRecord
  belongs_to :user
  has_many :lists, dependent: :destroy
  validates :title, presence: true, length: {maximum: 150}
  validates :description, length: { maximum: 2000 }, allow_blank: true
end
