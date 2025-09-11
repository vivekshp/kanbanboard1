require 'rails_helper'

RSpec.describe List, type: :model do
  it "is valid with a title and board" do
    list = FactoryBot.build(:list, title: "Todo")
    expect(list).to be_valid
  end
end
