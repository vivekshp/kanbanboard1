# spec/requests/tasks_spec.rb
require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  let(:user)  { FactoryBot.create(:user) }
  let!(:board){ FactoryBot.create(:board, user: user) }
  let!(:list) { FactoryBot.create(:list, board: board) }
  let!(:task) {FactoryBot.create(:task, list: list)}
  let(:valid_params)   { { task: { title: "New Task", description: "desc", position: 1 } } }
  let(:invalid_params) { { task: { title: "" } } }

  before { sign_in(user) }

  describe "GET /boards/:board_id/lists/:list_id/tasks" do
    it "returns all tasks for the list" do
      get "/boards/#{board.id}/lists/#{list.id}/tasks"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['data']).to be_a(Array)
    end
  end

  describe "POST /boards/:board_id/lists/:list_id/tasks" do
    it "creates a task with valid params" do
      post "/boards/#{board.id}/lists/#{list.id}/tasks",
           params:valid_params, as: :json
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['data']['title']).to eq('New Task')
    end

    it "returns error for invalid params" do
      post "/boards/#{board.id}/lists/#{list.id}/tasks", params: invalid_params, as: :json
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "PATCH /boards/:board_id/lists/:list_id/tasks/:id" do
    it "updates the task" do
      patch "/boards/#{board.id}/lists/#{list.id}/tasks/#{task.id}",
            params: { task: { title: "Updated Task" } },
            as: :json

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['data']['title']).to eq('Updated Task')
    end
  end

  describe "DELETE /boards/:board_id/lists/:list_id/tasks/:id" do
    it "deletes the task" do
      delete "/boards/#{board.id}/lists/#{list.id}/tasks/#{task.id}"
      expect(response).to have_http_status(:no_content)
    end
  end
end