class CreateTenants < ActiveRecord::Migration[8.0]
  def change
    create_table :tenants do |t|
      t.string :name
      t.string :domain
      t.string :db_name
      t.json :db_config
      t.boolean :active

      t.timestamps
    end
  end
end
