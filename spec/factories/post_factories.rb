FactoryGirl.define do
  factory :post do
    content "Lorem ipsum post"
    creator
    receiver
  end
end
