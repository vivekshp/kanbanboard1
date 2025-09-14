class AddForeignKeysToTaskAssignments < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :task_assignments, :users, column: :assigned_by_id
  end
end
