class BoardMemberPolicy < ApplicationPolicy
  def create?
    BoardPolicy.new(user, record.board).invite?
  end

  def index?
    BoardPolicy.new(user, record.board).show?
  end

  def destroy?
    return true if record.user_id == user.id && record.pending?
    BoardPolicy.new(user, record.board).manage_members?
  end

  def update?
    return true if record.user_id == user.id && record.pending?

    BoardPolicy.new(user, record.board).manage_members?
  end

  class Scope < Scope
    def resolve
      scope.joins(:board).where('boards.user_id = :uid OR (board_members.user_id = :uid AND board_members.status = :accepted)', uid: user.id,accepted: BoardMember.statuses[:accepted])
    end
  end
end
