class CreateSearchIndices < ActiveRecord::Migration[8.0]
  def change
    create_table :search_indices do |t|
      t.string  :record_type, null: false
      t.bigint  :record_id,   null: false
      t.bigint  :task_id
      t.bigint  :board_id
      t.bigint  :assignee_id
      t.integer :status
      t.text    :content,     null: false

      t.timestamps
    end

    add_index :search_indices, [:record_type, :record_id], unique: true
    add_index :search_indices, :task_id
    add_index :search_indices, :board_id
    add_index :search_indices, :assignee_id
    add_index :search_indices, :status

    execute "ALTER TABLE search_indices ADD FULLTEXT INDEX index_search_indices_on_content (content)"
  end
end
