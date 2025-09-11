class Board < ApplicationRecord
  belongs_to :user
  has_many :lists, dependent: :destroy
  has_many :board_members, dependent: :destroy
  has_many :members, through: :board_members, source: :user
  validates :title, presence: true, length: {maximum: 150}
  validates :description, length: { maximum: 2000 }, allow_blank: true


 def owner?(u)
  user_id == u&.id
 end

 def role_for(u)
  return :owner if owner?(u)
  bm = board_members.find_by(user_id: u&.id, status: BoardMember.statuses[:accepted])
  bm&.role&.to_sym
 end

 def admin?(u)
  role_for(u) == :admin
 end

 def member?(u)
  [:admin, :member].include?(role_for(u))
 end

 def viewer?(u)
  role_for(u) == :viewer
 end
end
