FactoryBot.define do
  factory :board do
    association :user
    title { "Test Board" }
    description { "Test Description" }
    
  end
end
