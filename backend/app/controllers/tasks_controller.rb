# app/controllers/tasks_controller.rb
class TasksController < ApplicationController
    before_action :set_board
    before_action :set_list
    before_action :set_task, only: [:show, :update, :destroy]
  
    def index
      tasks = @list.tasks.order(:position, :created_at)
      render_success(tasks)
    end
  
    def show
      render_success(@task)
    end
  
    def create
      # Optional: enforce WIP limit per list
      if @list.limit.present? && @list.tasks.count >= @list.limit
        return render_error("List limit reached (#{@list.limit})", status: :unprocessable_content)
      end
  
      attrs = task_params
      attrs[:position] ||= (@list.tasks.maximum(:position) || 0) + 1
  
      task = @list.tasks.new(attrs)
      if task.save
        render_success(task, status: :created)
      else
        render_error(task.errors.full_messages, status: :unprocessable_content)
      end
    end
  
    def update
        ActiveRecord::Base.transaction do
          attrs = task_params
          if attrs[:list_id].present? && attrs[:list_id].to_i != @list.id
            dest = @board.lists.find(attrs[:list_id])
            if dest.limit.present? && dest.tasks.count >= dest.limit
              return render_error("List limit reached (#{dest.limit})", status: :unprocessable_content)
            end
          end
      
          if @task.update(attrs)
            render_success(@task)
          else
            render_error(@task.errors.full_messages, status: :unprocessable_content)
          end
        end
      end
  
    # DELETE /boards/:board_id/lists/:list_id/tasks/:id
    def destroy
      @task.destroy
      head :no_content
    end
  
    private
  
    def set_board
      @board = current_user.boards.find(params[:board_id])
    rescue ActiveRecord::RecordNotFound
      render_error('Board not found', status: :not_found)
    end
  
    def set_list
      @list = @board.lists.find(params[:list_id])
    rescue ActiveRecord::RecordNotFound
      render_error('List not found', status: :not_found)
    end
  
    def set_task
      @task = @list.tasks.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render_error('Task not found', status: :not_found)
    end
  
    def task_params
      src = params[:task].presence || params
      src.permit(:title, :description, :position, :due_date, :list_id)
    end
  end