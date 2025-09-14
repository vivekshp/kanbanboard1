class CreateHistories < ActiveRecord::Migration[8.0]
  def change
    create_table :histories do |t|
      t.string :record_type, null: false
      t.bigint :record_id, null: false
      t.string :action, null: false 
      t.bigint :modified_by
      t.datetime :time,  null: false

      t.timestamps
    end
  end
end
