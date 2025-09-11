require 'rails_helper'

RSpec.describe BoardMember, type: :model do
  it "is valid with a user, board, and role" do
    board_member = FactoryBot.build(:board_member, role: :member)
    expect(board_member).to be_valid
  end
end

