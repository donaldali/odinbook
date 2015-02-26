class Profile < ActiveRecord::Base
  belongs_to :user

  validates :access_to,          presence: true
  validates :email_notification, inclusion: { in: [true, false] }
end
