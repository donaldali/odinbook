FactoryGirl.define do
  factory :comment do 
    content "Lorem ipsum comment"
    post
    commenter
  end
end
