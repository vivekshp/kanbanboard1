class TaskPolicy < ApplicationPolicy
  def show?
    BoardPolicy.new(user, record.list.board).show?
  end

  def create?
    role_allowed_on_board?(record.list.board, [:admin, :member]) || owner?(record.list.board)
  end

  def update?
    assigned = TaskAssignment.exists?(task_id: record.id, user_id: user.id)
  assigned || role_allowed_on_board?(record.list.board, [:admin, :member]) || owner?(record.list.board)
  end

  def destroy?
    owner?(record.list.board) ||
      role_allowed_on_board?(record.list.board, [:admin]) ||
      (record.user_id == user.id)
  end

  private

  def owner?(board)
    board.user_id == user&.id
  end

  def role_allowed_on_board?(board, roles)
    board.board_members.where(user_id: user&.id, status: BoardMember.statuses[:accepted], role: roles.map { |r| BoardMember.roles[r] }).exists?
  end
end
