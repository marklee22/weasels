FactoryGirl.define do 
  factory :user do
    first_name "Mark"
    last_name "Lee"
    email "MarkLee805@gmail.com"
    password "password"
    password_confirmation "password"
  end
  
  factory :team do
    location "San Francisco"
    name "49ers"
    abbr "SF"
  end
end
  