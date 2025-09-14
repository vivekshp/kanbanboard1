class AddModifiedToToHistories < ActiveRecord::Migration[8.0]
  def change
    add_column :histories, :modified_to, :json
  end
end
