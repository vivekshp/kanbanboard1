class InvitesController < ApplicationController
  def index
  invites = BoardMember.includes(:board)
    .where(user_id: current_user.id, status: BoardMember.statuses[:pending])
    .map do |invite|
      invite.as_json.merge(title: invite.board.title)
    end
  render_success(invites)
end

  def update
    invite = BoardMember.find(params[:id])
    authorize invite
    return render_error(['Not your invite'], status: :forbidden) unless invite.user_id == current_user.id
    status = params[:status].to_s == 'accepted' ? 'accepted' : 'pending'
    if invite.update(status: status)
      render_success(invite)
    else
      render_error(invite.errors.full_messages, status: :unprocessable_content)
    end
  end

  def destroy
    invite = BoardMember.find(params[:id])
    authorize invite
    return render_error(['Not your invite'], status: :forbidden) unless invite.user_id == current_user.id
    invite.destroy
    head :no_content
  end
end