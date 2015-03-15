class LikesController < ApplicationController

  include LikesHelper

  before_action :authorize_self_like, only: [:destroy]

  def create
    like = current_user.likes.create(likeable_id:   params[:likeable_id],
                                     likeable_type: params[:likeable_type])
    @like_data = like_data(like)
    
    respond_to do |format|
      format.html { redirect_to :back }
      format.js   { render "create_destroy" }
    end
    WebsocketRails[:updates].trigger(:update_like, get_like_info(like))
  end

  def destroy
    like       = Like.find(params[:id])
    @like_data = like_data(like)
    like_info  = get_like_info(like)
    like.destroy
    
    respond_to do |format|
      format.html { redirect_to :back }
      format.js   { render "create_destroy" }
    end
    WebsocketRails[:updates].trigger(:update_like, like_info)
  end

  def create_destroy
    @like_data = like_data(nil, params[:options])
  end


  private


  def authorize_self_like
    user = Like.find(params[:id]).user
    msg  = "You can only delete a like you created"
    authorize_user!(user, :self, msg)
  end
end
