require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with an email and password" do
    user = FactoryBot.build(:user, email: "user@example.com", password: "password123")
    expect(user).to be_valid
  end
end
