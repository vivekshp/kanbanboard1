class ListPolicy < ApplicationPolicy
  def show?
    BoardPolicy.new(user, record.board).show?
  end

  def create?
    allowed_roles = [:admin, :member]
    owner?(record.board) || role_in_board?(record.board, allowed_roles)
  end

  def update?
    create?
  end

  def destroy?
    owner?(record.board) || role_in_board?(record.board, [:admin])
  end

  private

  def owner?(board)
    board.user_id == user&.id
  end

  def role_in_board?(board, allowed_roles)
    board.board_members.where(user_id: user&.id, status: BoardMember.statuses[:accepted], role: allowed_roles.map { |r| BoardMember.roles[r] }).exists?
  end
end
