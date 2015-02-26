FactoryGirl.define do
  factory :profile do 
    access_to "All Users"
    email_notification true
    user
  end
end
