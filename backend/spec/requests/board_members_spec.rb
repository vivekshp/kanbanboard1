require 'rails_helper'

RSpec.describe "BoardMembers", type: :request do
  let(:user)  { FactoryBot.create(:user) } 
  let(:other) { FactoryBot.create(:user) }
  let!(:board) { FactoryBot.create(:board, user: user) }
  

  
  let!(:owner_member) { create(:board_member, :admin, board: board, user: user, status: :accepted) }
  let!(:member_member) { create(:board_member, :member, board: board, user: other, status: :accepted) }
  let!(:viewer_member) { create(:board_member, :viewer, board: board, user: FactoryBot.create(:user), status: :accepted) }
  

  before { sign_in(user) }

  describe "GET /boards/:board_id/members" do
    it "returns all members of the board" do
      get "/boards/#{board.id}/members"
      expect(response).to have_http_status(:ok)
      data = JSON.parse(response.body)["data"]
      expect(data).to be_an(Array)
      expect(data.size).to eq(3) 
    end
  end

  describe "POST /boards/:board_id/members" do
    it "adds a new member" do
      new_user = FactoryBot.create(:user)

      post "/boards/#{board.id}/members",
           params: { board_member: { user_id: new_user.id, role: "member" } },
           as: :json

      expect(response).to have_http_status(:created)
      data = JSON.parse(response.body)["data"]
      expect(data["user_id"]).to eq(new_user.id)
      expect(data["role"]).to eq("member")
    end

    it "fails with invalid params" do
      post "/boards/#{board.id}/members",
           params: { board_member: { user_id: nil, role: "member" } },
           as: :json

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PATCH /boards/:board_id/members/:id" do
    it "updates a member role" do
      patch "/boards/#{board.id}/members/#{member_member.id}",
            params: { role: "admin" },
            as: :json

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["data"]["role"]).to eq("admin")
    end
  end

  describe "DELETE /boards/:board_id/board_members/:id" do
    it "removes a member" do
      delete "/boards/#{board.id}/members/#{viewer_member.id}"
      expect(response).to have_http_status(:no_content)
      expect(BoardMember.exists?(viewer_member.id)).to be false
    end
  end
end
