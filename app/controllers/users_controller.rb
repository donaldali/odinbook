class UsersController < ApplicationController
  include UsersHelper

  before_action :authorize_friends, only: [:friends]
  before_action ->(action = params[:action]) { authorize_self_user(action) },
                   only: [:newsfeed, :friend_requests, :find_friends]

  def newsfeed
    set_instance_variables("newsfeed")
    @posts = current_user.newsfeed_feed.paginate(page: params[:page], per_page: 10)
    
    respond_to do |format|
      format.html
      format.js { render "feed" }
    end
  end

  def timeline
    set_instance_variables("timeline")
    @posts = User.find(params[:id]).timeline_feed.
                  paginate(page: params[:page], per_page: 10)

    respond_to do |format|
      format.html { render layout: "profiles" }
      format.js   { render "feed" }
    end
  end

  def index
    set_instance_variables("index")
    @users = User.paginate(page: params[:page], per_page: 15).alphabetize
    
    respond_to do |format|
      format.html
      format.js { render "shared/user_index" }
    end
  end

  def friends
    set_instance_variables("friends")
    @users = User.find(@receiver_id).friends.
                  paginate(page: params[:page], per_page: 15)

    respond_to do |format|
      format.html { (params[:from] != "profile") ? (render "index") :
          (render template: "profiles/friends", layout: "layouts/profiles") }
      format.js   { render "shared/user_index" }
    end
  end

  def friend_requests
    set_instance_variables("friend_requests")
    @users = current_user.requests_from.paginate(page: params[:page], per_page: 15)
    
    respond_to do |format|
      format.html { render "index" }
      format.js   { render "shared/user_index" }
    end
  end

  def find_friends
    set_instance_variables("find_friends")
    @users = current_user.no_friendship.paginate(page: params[:page], per_page: 15)
    
    respond_to do |format|
      format.html { render "index" }
      format.js   { render "shared/user_index" }
    end
  end

  def search
    redirect_to :back and return if params[:q].blank?

    @is_index = true
    @users = User.search(params[:q]).paginate(page: params[:page], per_page: 15)

    respond_to do |format|
      format.html
      format.js { render "shared/user_index" }
    end
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
      msg = "#{user.first_name} doesn't publicly share #{user.genderize}"\
            " list of friends."
      authorize_user!(user, :public, msg)
    else
      msg = "Try viewing #{user.first_name}'s friends from"\
            " #{user.genderize} Timeline."
      authorize_user!(user, :self, msg)
    end
  end

end
