FactoryBot.define do
  factory :tenant do
    name { "MyString" }
    domain { "MyString" }
    db_name { "MyString" }
    db_config { "" }
    active { false }
  end
end
