FactoryGirl.define do
  factory :post_like, class: 'Like' do
    association :likeable, factory: :post
    user
  end

  factory :comment_like, class: 'Like' do
    association :likeable, factory: :comment
    user
  end
end
