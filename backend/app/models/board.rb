class Board < ApplicationRecord
  belongs_to :user
  has_many :lists, dependent: :destroy
  has_many :board_members, dependent: :destroy
  has_many :members, through: :board_members, source: :user
  validates :title, presence: true, length: {maximum: 150}
  validates :description, length: { maximum: 2000 }, allow_blank: true

   after_commit :update_search_index, on: [:create, :update]
   after_commit :delete_search_index, on: [:destroy]
   
   after_commit -> { log_history(action: 'created', user_id: Current.user&.id, modified_to: attributes.slice('title','description')) }, on: :create
   after_commit :log_update_history, on: :update
   after_commit -> { log_history(action: 'deleted', user_id: Current.user&.id, modified_to: attributes.slice('title','description')) }, on: :destroy

  


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



  private

  def update_search_index
    SearchIndex.upsert_board(self)
  end

  def delete_search_index
    SearchIndex.where(record_type: "Board", record_id: id).delete_all
  end

  def log_update_history
    changes = previous_changes.except('created_at', 'updated_at')
    interesting = changes.slice('title', 'description')
    log_history(action: 'updated', user_id: Current.user&.id, modified_to: interesting)
  end
end
