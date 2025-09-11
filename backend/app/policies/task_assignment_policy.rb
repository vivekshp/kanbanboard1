class TaskAssignmentPolicy < ApplicationPolicy
  def create?
    member_or_admin?
  end

  def destroy?
    member_or_admin?
  end

  private

  def member_or_admin?
    board = record.task.list.board
    BoardMember.exists?(
      board_id: board.id,
      user_id: user.id,
      status: BoardMember.statuses[:accepted],
      role: [BoardMember.roles[:member], BoardMember.roles[:admin]]
    )
  end
end
