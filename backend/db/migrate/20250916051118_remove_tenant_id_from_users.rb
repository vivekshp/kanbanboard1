class RemoveTenantIdFromUsers < ActiveRecord::Migration[8.0]
  def change
    if foreign_key_exists?(:users, :tenants)
      remove_foreign_key :users, :tenants
    end

    if index_exists?(:users, :tenant_id)
      remove_index :users, :tenant_id
    end

    if column_exists?(:users, :tenant_id)
      remove_column :users, :tenant_id, :bigint
    end

  end
end
