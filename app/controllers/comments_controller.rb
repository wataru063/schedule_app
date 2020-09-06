class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.build(comment_params)
    @construction = Construction.find(params[:comment][:construction_id])
    @comment.save
    respond_to do |format|
      format.html { redirect_to calendar_index_url(current_user) }
      format.js
    end
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    @comment.update_attribute(comment_params)
    respond_to do |format|
      format.html { redirect_to calendar_index_url(current_user) }
      format.js
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @construction = Construction.find(params[:construction_id])
    @comment.delete
    respond_to do |format|
      format.html { redirect_to calendar_index_url(current_user) }
      format.js
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :construction_id)
  end
end
