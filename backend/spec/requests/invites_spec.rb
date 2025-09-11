require 'rails_helper'

RSpec.describe "Invites", type: :request do
  let(:user) { create(:user) }
  let!(:board) { create(:board, user: user) }
  
  let!(:invite) { create(:board_member, board: board, user: user, status: :pending) }

  before { sign_in(user) }

  describe "GET /index" do
    it "returns http success" do
      get "/invites/index"
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /update" do
    it "updates an invite" do
      patch "/invites/#{invite.id}", params: { status: "accepted" }
      expect(response).to have_http_status(:ok)
    end
  end
  
  describe "DELETE /destroy" do
    it "removes an invite" do
      delete "/invites/#{invite.id}"
      expect(response).to have_http_status(:no_content)
    end
  end

end
