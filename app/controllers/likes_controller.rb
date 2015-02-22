class LikesController < ApplicationController
  def create
    current_user.likes.create(likeable_id:   params[:likeable_id],
                              likeable_type: params[:likeable_type])
    redirect_to :back
  end

  def destroy
    Like.find(params[:id]).destroy
    redirect_to :back
  end
end
