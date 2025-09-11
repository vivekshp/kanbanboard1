class BoardsController < ApplicationController
    before_action :set_board, only: [:show, :update, :destroy]
  
    def index
      boards = policy_scope(Board).order(created_at: :desc)
    
      render_success(boards)
    end
  
    def show
      authorize @board
      render_success(BoardSerializer.new(@board, current_user: current_user).as_json)
    end
  
    def create
      board = current_user.boards.new(board_params)
      authorize board
      if board.save
        board.board_members.create(user: current_user, role: 'admin', status: 'accepted')
        render_success(board, status: :created)
      else
        render_error(board.errors.full_messages)
      end
    end
  
    def update
      authorize @board
      if @board.update(board_params)
        render_success(@board)
      else
        render_error(@board.errors.full_messages)
      end
    end
  
    def destroy
        authorize @board
        if @board.destroy
          render_success(nil, status: :no_content)
        else
          render_error(@board.errors.full_messages, status: :unprocessable_entity)
        end
      end
  
    private
  
    def set_board
      @board = Board
        .left_outer_joins(:board_members)
        .where('boards.id = :id AND (boards.user_id = :uid OR board_members.user_id = :uid)', id: params[:id], uid: current_user.id)
        .distinct
        .first
    
      render_error(['Board not found or not accessible'], status: :not_found) unless @board
    end
    
  
    def board_params
        params.require(:board).permit(:title, :description)
    end
  end
  