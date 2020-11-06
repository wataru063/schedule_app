class GuestSessionsController < ApplicationController
  def create
    guest_user = ["admin@admin.com", "construction@guestuser.com", "supply-demand@guestuser.com"]
    if guest_user.include?(params[:email])
      user = User.find_by(email: params[:email])
      log_in user
      flash[:success] = "ゲストユーザーとしてログインしました。"
      redirect_to calendar_index_url
    end
  end
end
