class SearchController < ApplicationController
  def index
  q = params[:q]
  assignees = params[:assignees]
  board_ids = Array(params[:boards])         
  date_after = params[:date_after]

  results = SearchIndex.all
  results = results.search(q: params[:q],assignee_id: params[:assignees]) if params[:q].present? || params[:assignees].present?

  results = results.where(board_id: board_ids) if board_ids.any?
  results = results.where("created_at > ?", date_after) if date_after.present?

  render json: results.limit(50).map do |r|
    {
      id: r.record_id,
      type: r.record_type,
      content: r.content,
      assignee_id: r.assignee_id,
      board_id: r.board_id,
      task_id: r.task_id,
      status: r.status,
      created_at: r.created_at
    }
  end
end

end
