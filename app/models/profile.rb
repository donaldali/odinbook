class Profile < ActiveRecord::Base
  attr_accessor :delete_picture

  belongs_to :user

  validates :access_to,          presence: true
  validates :email_notification, inclusion: { in: [true, false] }

  has_attached_file :picture, 
      styles: { v_lg_img: "160x160#", lg_img: "75x75#",
                  md_img: "40x40#",   sm_img: "32x32#",
                v_sm_img: "19x19#" }

  validates_attachment :picture, 
      size: { less_than: 500.kilobytes, 
              message: "must be less than 500KB" },
      content_type: { content_type: /^image\/(jpe?g|png|gif)$/,
                      message: "must be .jpeg, .jpg, .png, or .gif" }
  
  after_validation :remove_duplicate_errors
  before_save      :delete_requested_picture


  private


  def remove_duplicate_errors
    errors.delete(:picture)
  end

  def delete_requested_picture
    self.picture = nil if delete_picture == "1" && 
                          !picture_updated_at_changed?
  end
end
