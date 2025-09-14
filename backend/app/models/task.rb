class Task < ApplicationRecord
  belongs_to :list
  validates :title, presence: true
  validates :position, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  has_many :task_assignments, dependent: :destroy
  has_many :assignees, through: :task_assignments, source: :user

  after_commit :update_search_index, on: [:create, :update]
  after_commit :delete_search_index, on: [:destroy]

  after_commit :log_create_history, on: :create
  after_commit :log_update_history, on: :update
  after_commit :log_destroy_history, on: :destroy


  private

  def update_search_index
    SearchIndex.upsert_task(self)
  end

  def delete_search_index
    SearchIndex.where(record_type: "Task", record_id: id).delete_all
  end

  
  def log_create_history
    modified = attributes.slice('title', 'description', 'due_date')
    log_history(action: 'created', user_id: Current.user&.id, modified_to: modified)
  end

  def log_update_history
  changes = previous_changes.except('created_at', 'updated_at')

  interesting = changes.slice('title', 'description', 'due_date', 'list_id', 'position')


  if changes.key?('list_id')
    old_id, new_id = changes['list_id']
    old_list = List.find_by(id: old_id)&.title
    new_list = List.find_by(id: new_id)&.title
    interesting['status'] = { from: old_list, to: new_list }
    interesting.delete('list_id') 
  end

  log_history(
    action: 'updated',
    user_id: Current.user&.id, 
    modified_to: interesting
  )
end


  def log_destroy_history
    log_history(action: 'deleted', user_id: Current.user&.id, modified_to: attributes.slice('title', 'description'))
  end
end
