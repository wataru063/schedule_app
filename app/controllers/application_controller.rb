class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ApplicationHelper
  include SessionsHelper
  include ConstructionsHelper
  include OrdersHelper
  include EventsHelper

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください"
      redirect_to login_url
    end
  end

  def logged_in_user_for_top
    if logged_in?
      flash[:danger] = "ログインしています"
      if url = request.referer
        redirect_to url
      else
        redirect_to calendar_index_url
      end
    end
  end

  def correct_user
    @user = User.find(params[:id])
    unless current_user?(@user)
      flash[:danger] = "権限がありません"
      if url = request.referer
        redirect_to url
      else
        redirect_to @user
      end
    end
  end
end
