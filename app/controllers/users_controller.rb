class UsersController < ApplicationController
  include UsersHelper

  before_action :authorize_friends, only: [:friends]
  before_action ->(action = params[:action]) { authorize_self_user(action) },
                   only: [:newsfeed, :friend_requests, :find_friends]

  def newsfeed
    @receiver_id = params[:id]
    @label       = "Update Status"
    @placeholder = "What's on your mind?"
    @posts       = current_user.newsfeed_feed
  end

  def timeline
    @receiver_id = params[:id]
    @label       = get_status(@receiver_id)
    @placeholder = get_placeholder(@receiver_id)
    @posts       = User.find(params[:id]).timeline_feed
    render layout: "profiles"
  end

  def index
    @users    = User.all.alphabetize
    @title    = "All Users"
    @is_index = true
  end

  def friends
    @receiver_id = params[:id]
    @users       = User.find(@receiver_id).friends
    @title       = "Friends"
    @is_index    = false
    if params[:from] == "profile"
      render template: "profiles/friends", layout: "layouts/profiles"
    else
      render "index"
    end
  end

  def friend_requests
    @users    = current_user.requests_from
    @title    = "Friend Requests"
    @is_index = false
    render "index"
  end

  def find_friends
    @users    = current_user.no_friendship - [current_user]
    @title    = "Find Friends"
    @is_index = false
    render "index"
  end


  private


  def authorize_self_user action
    user = User.find(params[:id])
    msg = case action
          when "newsfeed"        then "You can only view your newsfeed"
          when "friend_requests" then "You can only view your friend requests"
          when "find_friends"    then "You can only find friends for yourself"
          else ""
          end
    authorize_user!(user, :self, msg)
  end

  def authorize_friends
    user = User.find(params[:id])

    if params[:from] == "profile"
      msg = "#{user.first_name} doesn't publicly share #{user.genderize} list of friends."
      authorize_user!(user, :public, msg)
    else
      msg = "Try viewing #{user.first_name}'s friends from #{user.genderize} Timeline."
      authorize_user!(user, :self, msg)
    end
  end
end
