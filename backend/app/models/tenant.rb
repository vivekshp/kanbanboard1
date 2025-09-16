class Tenant < ApplicationRecord
    has_many :users
    validates :name, :domain, :db_name, presence: true
    validates :domain, :db_name, uniqueness: true

  def db_configuration
    db_config.merge('database' => db_name)
  end
end
