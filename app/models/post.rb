class Post < ActiveRecord::Base
  belongs_to :creator,  class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  validates :content,     presence: true
  validates :creator_id,  presence: true
  validates :receiver_id, presence: true
end
