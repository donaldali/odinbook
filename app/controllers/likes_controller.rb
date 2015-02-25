class LikesController < ApplicationController
  def create
    @like = current_user.likes.create(likeable_id:   params[:likeable_id],
                                      likeable_type: params[:likeable_type])
    
    respond_to do |format|
      format.html { redirect_to :back }
      format.js   { render "create_destroy" }
    end
  end

  def destroy
    @like = Like.find(params[:id])
    @like.destroy
    
    respond_to do |format|
      format.html { redirect_to :back }
      format.js   { render "create_destroy" }
    end
  end
end
