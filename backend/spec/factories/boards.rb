FactoryBot.define do
  factory :board do
    title { "Test Board" }
    description { "Test Description" }
    user { nil }
  end
end
