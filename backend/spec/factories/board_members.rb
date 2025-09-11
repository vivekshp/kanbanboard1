FactoryBot.define do
  factory :board_member do
    association :user
    association :board
    role { "member" }  
    status { :accepted } 

    trait :admin do
      role { "admin" }
      status { :accepted }
    end

    trait :viewer do
      role { "viewer" }
      status { :accepted }
    end
  end
end
