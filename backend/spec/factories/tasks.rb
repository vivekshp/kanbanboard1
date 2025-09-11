FactoryBot.define do
  factory :task do
    association :list
    title { "Test Task" }
    description { "Test description" }
    position { 1 }
    due_date { "2025-09-09 09:04:48" }
  end
end
