class CommentsController < ApplicationController
  def create
    content = params[:comment][:content]
    unless content.blank?
      current_user.comments.create(content: content, 
                                   post_id: params[:post_id])
    end

    redirect_to :back
  end

  def destroy
    Comment.find(params[:id]).destroy
    redirect_to :back
  end

end
