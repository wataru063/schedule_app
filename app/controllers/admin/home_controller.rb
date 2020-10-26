class Admin::HomeController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user

  def top
    @categories = Category.all
    @sort_column = params[:column].presence || 'category_id'
    @all_users = User.all
    @users = @all_users.order(@sort_column + ' ' + sort_direction).page(params[:page]).per(13)
    @count = @all_users.count
    @search_params = search_params
  end

  private

  def search_params
    params.permit(:name, :email, :category_id)
  end
end
