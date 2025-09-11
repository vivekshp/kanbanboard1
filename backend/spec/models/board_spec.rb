require 'rails_helper'

RSpec.describe Board, type: :model do
  it "is valid with a title" do
    board = FactoryBot.build(:board, title: "Test Board")
    expect(board).to be_valid
  end
end
