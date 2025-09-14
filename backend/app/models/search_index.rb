class SearchIndex < ApplicationRecord
  validates :record_type, :record_id, :content, presence: true

  def self.upsert_task(task)
    assignee = task.task_assignments.order(created_at: :desc).first&.user
    board = task.list&.board

    content = [
      task.title,
      task.description,
      assignee&.name
    ].compact.join(" ").downcase

    record = find_or_initialize_by(record_type: "Task", record_id: task.id)
    record.task_id     = task.id
    record.board_id    = board&.id
    record.assignee_id = assignee&.id
    record.content     = content
    record.save!
  end


  def self.upsert_board(board)
    owner = board.user
    members = board.members.pluck(:name)

    content = [
      board.title,
      board.description,
      owner&.name,
      members.join(" ")
    ].compact.join(" ").downcase

    record = find_or_initialize_by(record_type: "Board", record_id: board.id)
    record.board_id    = board.id
    record.assignee_id = owner&.id  
    record.content     = content
    record.save!
  end

  def self.search(q: nil, assignee_id: nil, board_id: nil, limit: 50)
    rel = all

    if q.present?
      tokens = q.strip.split(/\s+/).map { |t| "#{t}*" }.join(" ")
      rel = rel.where("MATCH(content) AGAINST(? IN BOOLEAN MODE)", tokens)
    end

     if assignee_id.present?
    assignee_ids = Array(assignee_id)
    rel = rel.where(assignee_id: assignee_ids)
  end
    rel = rel.where(board_id: board_id) if board_id.present?

    rel.limit(limit)
  end
end
