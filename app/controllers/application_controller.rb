class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ApplicationHelper
  include SessionsHelper
  include ConstructionsHelper
  include OrdersHelper
  include EventsHelper
  include UsersHelper

  def logged_in_user
    return if logged_in?
      store_location
      flash[:danger] = "ログインしてください"
      redirect_to login_url
  end

  def admin_user
    return if current_user.admin?
    flash[:danger] = "アクセス権限がありません"
    url = request.referer
    url.present? ? redirect_to(url) : redirect_to(calendar_index_url)
  end

  def logged_in_user_for_top
    return unless logged_in?
    flash[:danger] = "ログインしています"
    url = request.referer
    url.present? ? redirect_to(url) : redirect_to(calendar_index_url)
  end

  def correct_user
    @user = User.find(params[:id])
    return if current_user?(@user)
    flash[:danger] = "権限がありません"
    url = request.referer
    url.present? ? redirect_to(url) : redirect_to(calendar_index_url)
  end
end
