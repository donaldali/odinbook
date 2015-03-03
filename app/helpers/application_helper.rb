module ApplicationHelper   
  # Before action/filter used to ensure a user has a certain
  # relationship/friendship level with the current user.
  def authorize_user!(user, access_level, msg)
    unless access_level?(user, access_level)
      flash[:alert] = "Access denied. #{msg}"
      redirect_to user_root_path(current_user)
    end
  end

  def authorize_either_user!(user1, user2, access_level, msg)
    unless access_level?(user1, access_level) || 
           access_level?(user2, access_level)
      flash[:alert] = "Access denied. #{msg}"
      redirect_to user_root_path(current_user)
    end
  end

  # Check if a user is authorized up to a certain level
  def access_level?(user, level_requested)
    access_levels = { self: 4, friend: 3, friends: 3, public: 2, private: 1 }
    return false if access_levels[level_requested].nil?

    level_granted = if current_user == user
                      :self
                    elsif current_user.friends_with?(user)
                      :friend
                    elsif user.profile.access_to == ACCESS[:all]
                      :public
                    else
                      :private
                    end
    access_levels[level_granted] >= access_levels[level_requested]
  end
end
