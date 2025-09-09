FactoryBot.define do
  factory :list do
    title { "Sample List" }
    limit { 10 }
    position { 1 }
    board { nil }
  end
end
