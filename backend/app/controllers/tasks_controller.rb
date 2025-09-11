
class TasksController < ApplicationController
    before_action :set_board
    before_action :set_list
    before_action :set_task, only: [:show, :update, :destroy]
  
    def index
      authorize @list, :show?
      tasks = @list.tasks.order(:position, :created_at)
      render_success(tasks.as_json(
    include: { assignees: { only: [:id, :name, :email] } }
  ))
    end
  
    def show
      authorize @task
      render_success(@task.as_json(
    include: { assignees: { only: [:id, :name, :email] } }
  ))
    end
  
    def create
      if @list.limit.present? && @list.tasks.count >= @list.limit
        return render_error("List limit reached (#{@list.limit})", status: :unprocessable_content)
      end
  
      attrs = task_params
      attrs[:position] ||= (@list.tasks.maximum(:position) || 0) + 1
  
      task = @list.tasks.new(attrs)
      authorize task
      if task.save
        render_success(task, status: :created)
      else
        render_error(task.errors.full_messages, status: :unprocessable_content)
      end
    end
  
    def update
      authorize @task
        ActiveRecord::Base.transaction do
          attrs = task_params
          if attrs[:list_id].present? && attrs[:list_id].to_i != @list.id
            dest = @board.lists.find(attrs[:list_id])
            if dest.limit.present? && dest.tasks.count >= dest.limit
              return render_error("List limit reached (#{dest.limit})", status: :unprocessable_content)
            end
          end
      
          if @task.update(attrs)
            render_success(@task.as_json(
    include: { assignees: { only: [:id, :name, :email] } }
  ))
          else
            render_error(@task.errors.full_messages, status: :unprocessable_content)
          end
        end
      end
  
    
    def destroy
      authorize @task
      @task.destroy
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