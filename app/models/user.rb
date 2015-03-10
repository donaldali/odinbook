class User < ActiveRecord::Base
  # Scope
  scope :alphabetize,        -> { order(:first_name, :last_name) }

  # Associations
  has_many :friendships, dependent: :destroy, foreign_key: :friender_id
  has_many :friended_users, through: :friendships, source: :friended
  has_many :reverse_friendships, class_name: "Friendship", 
                                 dependent: :destroy, 
                                 foreign_key: :friended_id
  has_many :frienders, through: :reverse_friendships, source: :friender
  has_many :notifications, dependent: :destroy
  has_many :created_posts,  class_name: 'Post', foreign_key: :creator_id,
                           dependent: :destroy
  has_many :received_posts, class_name: 'Post', foreign_key: :receiver_id,
                           dependent: :destroy
  has_many :comments, foreign_key: :commenter_id, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_one  :profile, dependent: :destroy

  # Validations
  validates :first_name, presence: true
  validates :last_name,  presence: true
  validates :gender,     presence: true

  # Callbacks
  before_create :build_default_profile

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :trackable 
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, 
         :omniauthable, :omniauth_providers => [:facebook]

  # Class methods
  def self.from_omniauth(auth)
    # where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    where(email: auth.info.email).first_or_create do |user|
      user.provider   = auth.provider
      user.uid        = auth.uid
      # user.email      = auth.info.email
      user.first_name = auth.info.first_name
      user.last_name  = auth.info.last_name
      user.gender     = auth.extra.raw_info.gender
      user.password   = Devise.friendly_token[0,20]
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && 
                session["devise.facebook_data"]["extra"]["raw_info"]
        user.email      = data["email"]      if user.email.blank?
        user.first_name = data["first_name"] if user.first_name.blank?
        user.last_name  = data["last_name"]  if user.last_name.blank?
        user.gender     = data["gender"]     if user.gender.blank?
        user.valid?
      end
    end
  end

  def self.unused_email?(email)
    !User.find_by(email: email)
  end

  # Instance methods
  def send_friend_request_to(other_user)
    unless self == other_user || friends_with?(other_user) || 
           has_friend_request_from?(other_user) ||
           other_user.has_friend_request_from?(self)
      self.friendships.create(friended_id: other_user.id, accepted: false)
    end
  end

  def accept_friend_request_from(other_user)
    friend_request = get_friend_request(other_user, self)
    friend_request && friend_request.update_attributes(accepted: true)
  end

  def reject_friend_request_from(other_user)
    friend_request = get_friend_request(other_user, self)
    friend_request && friend_request.destroy
  end

  def unfriend(other_user)
    friendship = get_friendship(self, other_user)
    friendship && friendship.destroy
  end

  def has_friend_request_from?(other_user)
    !get_friend_request(other_user, self).nil?
  end

  def friends_with?(other_user)
    !get_friendship(self, other_user).nil?
  end

  def friends
    friender_friends_ids = "SELECT friender_id FROM friendships 
                            WHERE friended_id = :user_id AND accepted = true"
    friended_friends_ids = "SELECT friended_id FROM friendships 
                            WHERE friender_id = :user_id AND accepted = true"

    User.where("id IN (#{friender_friends_ids}) OR 
                id IN (#{friended_friends_ids})", user_id: self.id)
        .alphabetize
  end

  def requests_from
    frienders_ids = "SELECT friender_id FROM friendships 
                     WHERE friended_id = :user_id AND accepted = false"

    User.where("id IN (#{frienders_ids})", user_id: self.id).alphabetize
  end

  def no_friendship
    frienders_ids = "SELECT friender_id FROM friendships 
                     WHERE friended_id = :user_id"
    friendeds_ids = "SELECT friended_id FROM friendships 
                     WHERE friender_id = :user_id"

    User.where("id NOT IN (#{frienders_ids}) AND NOT id = :user_id AND
                id NOT IN (#{friendeds_ids})", user_id: self.id).alphabetize
  end

  def newsfeed_feed
    friender_friends_ids      = "SELECT friender_id FROM friendships 
                                 WHERE friended_id = :user_id AND accepted = true"
    friended_friends_ids      = "SELECT friended_id FROM friendships 
                                 WHERE friender_id = :user_id AND accepted = true"

    user_created_posts_id     = "SELECT id FROM posts
                                 WHERE creator_id = :user_id"
    user_received_posts_id    = "SELECT id FROM posts
                                 WHERE receiver_id = :user_id"
    friends_created_posts_id  = "SELECT id FROM posts
                                 WHERE creator_id IN (#{friender_friends_ids}) OR
                                       creator_id IN (#{friended_friends_ids})"
    friends_received_posts_id = "SELECT id FROM posts
                                 WHERE receiver_id IN (#{friender_friends_ids}) OR
                                       receiver_id IN (#{friended_friends_ids})"

    Post.where("id IN (#{user_created_posts_id}) OR 
                id IN (#{user_received_posts_id}) OR 
                id IN (#{friends_created_posts_id}) OR 
                id IN (#{friends_received_posts_id})", user_id: self.id)
        .reverse_chronology
  end

  def timeline_feed
    created_posts_ids  = "SELECT id FROM posts
                          WHERE creator_id = :user_id"
    received_posts_ids = "SELECT id FROM posts
                          WHERE receiver_id = :user_id"
    Post.where("id IN (#{created_posts_ids}) OR 
                id IN (#{received_posts_ids})", user_id: self.id)
        .reverse_chronology
  end

  def name
    "#{first_name} #{last_name}"
  end

  def update_new_notifications
    increment!(:new_notifications)
  end

  def reset_new_notifications
    update_attributes(new_notifications: 0)
  end

  def genderize
    (gender == "male") ? "his" : "her"
  end


  private


  # Get the Friendship AR that represents the friendship between
  # two users. Return nil if the users are not friends
  def get_friendship(user1, user2)
    user1.friendships.find_by(friended_id: user2.id, accepted: true) ||
      user2.friendships.find_by(friended_id: user1.id, accepted: true)
  end

  # Get the Friendship AR that represents a friend request from
  # one user to another. Return nil if no such request exists
  def get_friend_request(from_user, to_user)
    from_user.friendships.find_by(friended_id: to_user.id, accepted: false)
  end

  def build_default_profile
    self.build_profile({ access_to: ACCESS[:all], email_notification: true })
    true
  end
end
