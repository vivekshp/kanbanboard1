class AddStatusToBoardMembers < ActiveRecord::Migration[8.0]
  def change
    add_column :board_members, :status, :integer, null: false, default: 0
  end
end
