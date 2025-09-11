class BoardPolicy < ApplicationPolicy
  def show?
    owner?(record, user) || accepted_member?(record, user)
  end

  def invite?
    owner?(record, user) || admin_member?(record, user)
  end

  def manage_members?
    owner?(record, user) || admin_member?(record, user)
  end

  def create?
    user.present?
  end

  def update?
    owner?(record, user) || admin_member?(record, user)
  end

  def destroy?
    owner?(record, user)
  end

  class Scope < Scope
    def resolve
      Board
        .left_outer_joins(:board_members)
        .where('boards.user_id = :uid OR (board_members.user_id = :uid AND board_members.status = :status)',uid: user.id,status: BoardMember.statuses[:accepted])
        .distinct
    end
  end

  private

  def owner?(board, user)
    board.user_id == user&.id
  end

  def accepted_member?(board, user)
    board.board_members.where(user_id: user&.id, status: BoardMember.statuses[:accepted]).exists?
  end

  def admin_member?(board, user)
    board.board_members.where(user_id: user&.id, role: BoardMember.roles[:admin], status: BoardMember.statuses[:accepted]).exists?
  end
end
