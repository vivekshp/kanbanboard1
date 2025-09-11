class BoardMembersController < ApplicationController
    before_action :set_board
    before_action :set_member, only: [:update, :destroy]
  
    def index
      authorize @board, :show?
      members = @board.board_members.includes(:user)
      render_success(
      members.as_json(include: { user: { only: [:id, :name, :email] } })
    )
    end
  
    def create
      authorize @board, :invite?
      user = User.find_by(id: invite_params[:user_id])
      return render_error(['User not found'],status: :unprocessable_entity) unless user
      return render_error(['Owner is already on the board'], status: :unprocessable_entity) if @board.owner?(user)
  
      bm = @board.board_members.find_or_initialize_by(user_id: user.id)
      bm.role = invite_params[:role].presence_in(BoardMember.roles.keys) || 'member'
      bm.status ||= 'pending'
      if bm.save
        render_success(bm.as_json(include: { user: { only: [:id, :name, :email] } }), status: :created)
      else
        render_error(bm.errors.full_messages, status: :unprocessable_entity)
      end
    end
  
    def update
      authorize @member
      if current_user.id == @member.user_id && @member.pending? && params[:status].present?
        @member.status = params[:status].to_s == 'accepted' ? 'accepted' : 'pending'
      end
      if params[:role].present? && BoardMember.roles.key?(params[:role]) && BoardPolicy.new(current_user, @board).manage_members?
        @member.role = params[:role]
      end
  
      if @member.changed? && @member.save
        render_success(@member.as_json(include: { user: { only: [:id, :name, :email] } }))
      else
        render_error(@member.errors.full_messages, status: :unprocessable_entity)
      end
    end
  
    def destroy
      authorize @member
      @member.destroy
      head :no_content
    end
  
    private
  
    def set_board
      @board = current_user.boards.find_by(id: params[:board_id]) ||
             Board.joins(:board_members).where(id: params[:board_id], board_members: { user_id: current_user.id }).first
      render_error(['Board not found or not accessible'], :not_found) unless @board
    end
  
    def set_member
      @member = @board.board_members.find(params[:id])
    end
  
    def invite_params
        params.require(:board_member).permit(:user_id, :role)
    end
  end