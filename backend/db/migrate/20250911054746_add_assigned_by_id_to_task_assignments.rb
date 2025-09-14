class AddAssignedByIdToTaskAssignments < ActiveRecord::Migration[8.0]
  def change
    add_column :task_assignments, :assigned_by_id, :bigint, null: false
  end
end
