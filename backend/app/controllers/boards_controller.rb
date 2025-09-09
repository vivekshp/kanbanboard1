class BoardsController < ApplicationController
    before_action :set_board, only: [:show, :update, :destroy]
  
    def index
      boards = current_user.boards.order(created_at: :desc)
      render_success(boards)
    end
  
    def show
      render_success(@board)
    end
  
    def create
      board = current_user.boards.new(board_params)
      if board.save
        render_success(board, status: :created)
      else
        render_error(board.errors.full_messages)
      end
    end
  
    def update
      if @board.update(board_params)
        render_success(@board)
      else
        render_error(@board.errors.full_messages)
      end
    end
  
    def destroy
        if @board.destroy
          render_success(nil, status: :no_content)
        else
          render_error(@board.errors.full_messages, status: :unprocessable_entity)
        end
      end
  
    private
  
    def set_board
      @board = current_user.boards.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render_error("Board not found", status: :not_found)
    end
  
    def board_params
        params.require(:board).permit(:title, :description)
    end
  end
  