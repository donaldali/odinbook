module UsersHelper
  def friend_status_of(user)
    if current_user.has_friend_request_from?(user)
      render "users/request_received", user: user
    elsif user.has_friend_request_from?(current_user)
      render "users/request_sent", user: user
    elsif current_user.friends_with?(user)
      render "users/unfriend", user: user
    else
      render "users/add_friend", user: user
    end
  end

  def get_friendship(user1, user2)
    user1.friendships.find_by(friended_id: user2.id, accepted: true) ||
      user2.friendships.find_by(friended_id: user1.id, accepted: true)
  end
end
