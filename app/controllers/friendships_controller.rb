class FriendshipsController < ApplicationController

  before_action :authorize_self_friended,          only: [:update]
  before_action :authorize_self_friender_friended, only: [:destroy]

  def create
    @is_index = params[:is_index]
    @user = User.find(params[:friended_id])
    current_user.send_friend_request_to(@user)
    Notification.send_notification(@user, "request", current_user.name)

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  def update
    @is_index = params[:is_index]
    @user = Friendship.find(params[:id]).friender
    current_user.accept_friend_request_from(@user)

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  def destroy
    @is_index = params[:is_index]
    @user     = User.find(params[:user_id])
    @unfriend = params[:unfriend]
    Friendship.find(params[:id]).destroy

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end


  private


  def authorize_self_friended
    user = Friendship.find(params[:id]).friended
    msg  = "You can only accept friend requests sent to you"
    authorize_user!(user, :self, msg)
  end

  def authorize_self_friender_friended
    friendship = Friendship.find(params[:id])
    friender   = friendship.friender
    friended   = friendship.friended
    msg        = "You can only delete a friendship you are part of"

    authorize_either_user!(friender, friended, :self, msg)
  end
end
