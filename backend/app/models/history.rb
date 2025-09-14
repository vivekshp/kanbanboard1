class History < ApplicationRecord
  belongs_to :modifier, class_name: 'User', foreign_key: :modified_by, optional: true

  validates :record_type, :record_id, :action, :time, presence: true

  def modified_to_hash
    modified_to.presence || {}
  end
end
