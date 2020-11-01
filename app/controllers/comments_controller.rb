class CommentsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:edit, :update, :destory]

  def create
    @comment = current_user.comments.build(comment_params)
    @comment.save
    params_id = params[:comment][:construction_id]
    @construction = Construction.find(params_id) if params_id.present?
    comment_respond_to_html_js
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    @comment.update_attribute(comment_params)
    comment_respond_to_html_js
  end

  def destroy
    @comment = Comment.find(params[:id])
    @construction = Construction.find(@comment.construction_id)
    @comment.delete
    comment_respond_to_html_js
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :construction_id)
  end

  def comment_respond_to_html_js
    respond_to do |format|
      format.html { redirect_to calendar_index_url }
      format.js
    end
  end
end
