
require 'rails_helper'

RSpec.describe "Lists", type: :request do
  let(:user)  { FactoryBot.create(:user) }
  let!(:board){ FactoryBot.create(:board, user: user) } 
  let!(:list) { FactoryBot.create(:list, board: board) } 
  let(:valid_params)   { { list: { title: "Todo", position: 1 } } }
  let(:invalid_params) { { list: { title: "" } } }

  before do
        sign_in(user)
  end 

  describe "GET /boards/:board_id/lists" do
    it "returns all lists for the board" do
      get "/boards/#{board.id}/lists"
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /boards/:board_id/lists" do
    it "creates a list with valid params" do
      post "/boards/#{board.id}/lists", params: valid_params, as: :json
      expect(response).to have_http_status(:created)
    end

    it "returns error for invalid params" do
      post "/boards/#{board.id}/lists", params: invalid_params, as: :json
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "PATCH /boards/:board_id/lists/:id" do
    let!(:list) { create(:list, board: board, title: "Old") }

    it "updates the list" do
      patch "/boards/#{board.id}/lists/#{list.id}", params: { list: { title: "New" } }, as: :json
      expect(response).to have_http_status(:ok)
    end
  end

  describe "DELETE /boards/:board_id/lists/:id" do
    let!(:list) { create(:list, board: board) }

    it "deletes the list" do
      delete "/boards/#{board.id}/lists/#{list.id}"
      expect(response).to have_http_status(:no_content)
    end
  end
end