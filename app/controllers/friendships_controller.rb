class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find(params[:friended_id])
    current_user.send_friend_request_to(@user)
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  def update
    @user = Friendship.find(params[:id]).friender
    current_user.accept_friend_request_from(@user)
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  def destroy
    @user     = User.find(params[:user_id])
    @unfriend = params[:unfriend]
    Friendship.find(params[:id]).destroy
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end
end
