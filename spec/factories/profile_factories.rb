FactoryGirl.define do
  factory :profile do 
    access_to ACCESS[:all]
    email_notification true
    user
  end
end
