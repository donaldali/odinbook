module UsersHelper

  def get_status receiver_id
    (receiver_id.to_s == current_user.id.to_s) ? "Status" : "Post"
  end

  def get_placeholder receiver_id
    (receiver_id.to_s == current_user.id.to_s) ? "What's on your mind?" : 
                                                 "Write something..."
  end

  def friend_status_of(user, is_index)
    return if current_user == user
    if current_user.has_friend_request_from?(user)
      render "users/request_received", user: user, is_index: is_index
    elsif user.has_friend_request_from?(current_user)
      render "users/request_sent"
    elsif current_user.friends_with?(user)
      render "users/unfriend", user: user, is_index: is_index
    else
      render "users/add_friend", user: user, is_index: is_index
    end
  end

  def get_friendship(user1, user2)
    user1.friendships.find_by(friended_id: user2.id, accepted: true) ||
      user2.friendships.find_by(friended_id: user1.id, accepted: true)
  end

  # Returns the image for a user giving priority to an uploaded image
  # over a fallback gravatar image
  def image_for(user, options = { img_class: "lg-img" })
    img_class = options[:img_class] || "lg-img"
    title     = options[:title] || ""

    url = if user.profile.picture?
            paperclip_url(user.profile.picture, img_class)
          else
            gravatar_url(user.email, img_class)
          end

    image_tag(url, class: img_class, title: title, 
              alt: "#{user.first_name}'s profile picture")
  end

  def paperclip_url(picture, img_class)
    if %w(v-lg-img lg-img md-img sm-img v-sm-img).include?(img_class)
      picture.url(img_class.gsub("-", "_").to_sym)
    else
      picture.url
    end
  end

  # Returns the Gravatar url for a given email
  def gravatar_url(email, img_class)
    gravatar_id  = Digest::MD5::hexdigest(email.downcase)
    size = case img_class
           when "v-lg-img" then 160
           when "lg-img"   then 75
           when "md-img"   then 40
           when "sm-img"   then 32
           when "v-sm-img" then 19
           else 75
           end
    "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
  end
  
end
