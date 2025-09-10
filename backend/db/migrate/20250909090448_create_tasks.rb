class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.references :list, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.integer :position
      t.datetime :due_date

      t.timestamps
    end
  end
end
