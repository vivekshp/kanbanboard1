class HistoriesController < ApplicationController
  def index
    scope = History.order(time: :desc)

    limit = (params[:limit] || 50).to_i
    offset = (params[:offset] || 0).to_i

    histories = scope.offset(offset).limit(limit).includes(:modifier)

    render json: histories.map { |h|
      {
        id: h.id,
        record_type: h.record_type,
        record_id: h.record_id,
        action: h.action,
        modified_by: h.modifier ? { id: h.modifier.id, name: h.modifier.name, email: h.modifier.email } : nil,
        modified_to: h.modified_to_hash,
        time: h.time,
        created_at: h.created_at
      }
    }
  end
end
