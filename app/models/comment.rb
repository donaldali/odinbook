class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :commenter, class_name: 'User'

  validates :content,      presence: true
  validates :post_id,      presence: true
  validates :commenter_id, presence: true
end
