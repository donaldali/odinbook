class CommentsController < ApplicationController
  def create
    content = params[:comment][:content]
    unless content.blank?
      @comment = current_user.comments.create(content: content, 
                                              post_id: params[:post_id])
    end

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

end
