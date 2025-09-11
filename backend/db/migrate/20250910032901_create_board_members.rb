class CreateBoardMembers < ActiveRecord::Migration[8.0]
  def change
    create_table :board_members do |t|
      t.references :board, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :role, null: false, default: 1  

      t.timestamps
    end
  end
end
