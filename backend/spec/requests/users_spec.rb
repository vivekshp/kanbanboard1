require 'rails_helper'

RSpec.describe "Users", type: :request do
  let!(:user)  { FactoryBot.create(:user) }
  before { sign_in(user) }
  describe "GET /users/search" do
    let!(:user1) { FactoryBot.create(:user, name: "Alice", email: "alice@example.com") }
    let!(:user2) { FactoryBot.create(:user, name: "Bob",   email: "bob@example.com") }
     
    it "returns matching users by name" do
      get "/users/search", params: { q: "Alice" }

      expect(response).to have_http_status(:ok)
      data = JSON.parse(response.body)["data"]
      expect(data).to be_an(Array)
      expect(data.first["name"]).to eq("Alice")
    end
  end
end
