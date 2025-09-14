class AssigneesController < ApplicationController
  before_action :authenticate_request

  def index
    board_id = params[:board_id]

    users = if board_id.present?
      User.joins(task_assignments: { task: :list })
          .where(lists: { board_id: board_id })
          .distinct
    else
      User.joins(:task_assignments).distinct
    end

    render json: users.select(:id, :name, :email)
  end
end
