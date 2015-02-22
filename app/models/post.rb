class Post < ActiveRecord::Base
  belongs_to :creator,  class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  has_many   :comments, dependent: :destroy
  has_many   :likes,    as: :likeable, dependent: :destroy

  validates :content,     presence: true
  validates :creator_id,  presence: true
  validates :receiver_id, presence: true

end
