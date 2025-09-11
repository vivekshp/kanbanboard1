require 'rails_helper'

RSpec.describe Task, type: :model do
  it "is valid with a title and list" do
    task = FactoryBot.build(:task, title: "Write tests")
    expect(task).to be_valid
  end
end
