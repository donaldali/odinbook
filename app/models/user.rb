class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :trackable 
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, 
         :omniauthable, :omniauth_providers => [:facebook]

  validates :first_name, presence: true
  validates :last_name,  presence: true

  def self.from_omniauth(auth)
    # where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    where(email: auth.info.email).first_or_create do |user|
      user.provider   = auth.provider
      user.uid        = auth.uid
      # user.email      = auth.info.email
      user.first_name = auth.info.first_name
      user.last_name  = auth.info.last_name
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
        user.valid?
      end
    end
  end
end
