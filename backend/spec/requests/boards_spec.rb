require 'rails_helper'

RSpec.describe "Boards", type: :request do
    let(:user) {FactoryBot.create(:user)}
    let!(:board){FactoryBot.create(:board,user: user)}
    let(:valid_params) { {title: 'Test Board', description: 'test description'} }

    before do
        sign_in(user)
    end
    
    describe "/get boards" do
        it "get all boards of current user" do
            get '/boards'
            expect(response).to have_http_status(:ok)
            expect(JSON.parse(response.body) ['data']).to be_present
        end
    end

    describe "/post boards" do
        it "create board with valid params" do
            post '/boards', params: { board: valid_params }, as: :json
            expect(response).to have_http_status(:created)
            expect(JSON.parse(response.body)['data']['title']).to eq('Test Board')
        end

        it "returns errors for invalid params" do
            post '/boards', params: { board: {title: ''} }, as: :json
            expect(response).to have_http_status(:unprocessable_content)
        end
    end

    describe "/patch boards/:id" do
        it "updates baord " do
            patch "/boards/#{board.id}", params: { board: {title:'Updated Board'} }, as: :json
            expect(response).to have_http_status(:ok)
            expect(JSON.parse(response.body)['data']['title']).to eq('Updated Board')
        end
    end 

    describe "delete /boards/:id" do
        it 'deletes board' do
            delete "/boards/#{board.id}"
            expect(response).to have_http_status(:no_content)
        end
    end
end

