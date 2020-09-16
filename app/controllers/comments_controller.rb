class CommentsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:edit, :update, :destory]

  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      @construction = Construction.find(params[:comment][:construction_id])
      respond_to do |format|
        format.html { redirect_to calendar_index_url }
        format.js
      end
    else
      render 'calendar/index'
    end
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    @comment.update_attribute(comment_params)
    respond_to do |format|
      format.html { redirect_to calendar_index_url }
      format.js
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @construction = Construction.find(@comment.construction_id)
    @comment.delete
    respond_to do |format|
      format.html { redirect_to calendar_index_url }
      format.js
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :construction_id)
  end
end
