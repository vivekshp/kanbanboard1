# app/controllers/lists_controller.rb
class ListsController < ApplicationController
    before_action :set_board
    before_action :set_list, only: [:show, :update, :destroy]
  
    def index
      lists = @board.lists.order(:position, :created_at)
      render_success(lists)
    end
  
    def show
      render_success(@list)
    end
  
    def create
      list = @board.lists.new(list_params)
      if list.save
        render_success(list, status: :created)
      else
        render_error(list.errors.full_messages, status: :unprocessable_content)
      end
    end
  
    def update
      if @list.update(list_params)
        render_success(@list)
      else
        render_error(@list.errors.full_messages, status: :unprocessable_content)
      end
    end
  
    def destroy
      @list.destroy
      head :no_content
    end
  
    private
  
    def set_board
      @board = current_user.boards.find(params[:board_id])
    rescue ActiveRecord::RecordNotFound
      render_error('Board not found', status: :not_found)
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