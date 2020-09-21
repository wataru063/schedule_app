class GuestSessionsController < ApplicationController
  def create
    user = User.find_by(email: "guestuser@example.com")
    log_in user
    flash[:success] = "ゲストログインしました。"
    redirect_to calendar_index_url
  end
end
