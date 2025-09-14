class TaskAssignment < ApplicationRecord
  belongs_to :task
  belongs_to :user
  belongs_to :assigned_by, class_name: "User"

  after_commit :update_task_index, on: [:create, :update, :destroy]
  after_commit :log_history, on: [:create, :destroy]

  private

  def update_task_index
    SearchIndex.upsert_task(task)
  end

  def log_history
    History.create!(
      record_type: "TaskAssignment",
      record_id: task_id,
      action: "assigned",
      modified_by: assigned_by_id,
      time: Time.current,
      modified_to: {
        assigned_to: user.name
      }
    )
  end
end
