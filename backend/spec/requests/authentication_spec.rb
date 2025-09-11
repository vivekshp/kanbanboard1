require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  describe 'POST /auth/register' do
    it 'creates user and returns JWT cookie' do
      post '/auth/register', params: FactoryBot.attributes_for(:user)
      
      expect(response).to have_http_status(:created)
      expect(cookies[:jwt]).to be_present
    end

    it 'returns errors for invalid data' do
      post '/auth/register', params: { name: '', email: 'invalid' }
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe 'POST /auth/login' do
    let!(:user) { FactoryBot.create(:user) }

    it 'logs in and returns JWT cookie' do
      post '/auth/login', params: { email: user.email, password: 'password123' }
      
      expect(response).to have_http_status(:ok)
      expect(cookies[:jwt]).to be_present
    end

    it 'returns 401 for wrong credentials' do
      post '/auth/login', params: { email: user.email, password: 'wrong' }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'DELETE /auth/logout' do
    it 'clears JWT cookie' do
      delete '/auth/logout'
      expect(response).to have_http_status(:ok)
      expect(response.cookies['jwt']).to be_nil
    end
  end
end