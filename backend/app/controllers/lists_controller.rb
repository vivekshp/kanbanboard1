# app/controllers/lists_controller.rb
class ListsController < ApplicationController
    before_action :set_board
    before_action :set_list, only: [:show, :update, :destroy]
  
    def index
      authorize @board, :show?
      lists = @board.lists.order(:position, :created_at)
      render_success(lists)
    end
  
    def show
      authorize @list
      render_success(@list)
    end
  
    def create
      list = @board.lists.new(list_params)
      authorize list
      if list.save
        render_success(list, status: :created)
      else
        render_error(list.errors.full_messages, status: :unprocessable_content)
      end
    end
  
    def update
      authorize @list
      if @list.update(list_params)
        render_success(@list)
      else
        render_error(@list.errors.full_messages, status: :unprocessable_content)
      end
    end
  
    def destroy
      authorize @list
      @list.destroy
      head :no_content
    end
  
    private
  
    def set_board
        @board = Board
          .left_outer_joins(:board_members)
          .where('boards.id = :id AND (boards.user_id = :uid OR board_members.user_id = :uid AND board_members.status = :status)', 
                 id: params[:board_id], uid: current_user.id, status: BoardMember.statuses[:accepted])
          .distinct
          .first
      
        render_error(['Board not found or not accessible'], status: :not_found) unless @board
      end
      
  
    def set_list
      @list = @board.lists.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render_error('List not found', status: :not_found)
    end
  
    def list_params
        params.require(:list).permit(:title, :position, :limit)
      
    end
  end