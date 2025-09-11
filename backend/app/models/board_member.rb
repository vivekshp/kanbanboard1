class BoardMember < ApplicationRecord
  belongs_to :board
  belongs_to :user

  enum :role, { admin: 0, member: 1, viewer: 2 }
  enum :status, { pending: 0, accepted: 1 }


  validates :role, presence: true
  validates :status, presence: true
  validates :user_id, uniqueness: { scope: :board_id }
end
