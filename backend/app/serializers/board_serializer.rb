class BoardSerializer
  def initialize(board, current_user:)
    @board = board
    @current_user = current_user
  end

  def as_json(*)
    {
      id: @board.id,
      title: @board.title,
      description: @board.description,
      role: role_for_user
    }
  end

  private

  def role_for_user
    if @board.user_id == @current_user.id
      'owner'
    else
      @board.board_members.find_by(user_id: @current_user.id)&.role
    end
  end
end
