class AddTenantFkToUsers < ActiveRecord::Migration[8.0]
  def change
     unless column_exists?(:users, :tenant_id)
      add_reference :users, :tenant, null: true, foreign_key: true
    end

    reversible do |dir|
      dir.down do
        # Only remove foreign key if it exists
        if foreign_key_exists?(:users, :tenants)
          remove_foreign_key :users, :tenants
        end

        # Only remove column if it exists
        remove_column :users, :tenant_id if column_exists?(:users, :tenant_id)
      end
    end
  end
end
