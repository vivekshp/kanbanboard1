class TaskAssignmentsController < ApplicationController
  before_action :set_task

  def create
    user = User.find(params[:user_id])
    assignment = @task.task_assignments.new(user: user)
    authorize assignment

    if assignment.save
      render_success(assignment, status: :created)
    else
      render_error(assignment.errors.full_messages, status: :unprocessable_content)
    end
  end

  def destroy
    assignment = @task.task_assignments.find_by!(user_id: params[:id])
    authorize assignment
    assignment.destroy
    head :no_content
  end

  private

  def set_task
    @task = Task.find(params[:task_id])
  end
end
