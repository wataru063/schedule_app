class Admin::HomeController < ApplicationController
  before_action :admin_user

  def top; end

  private

  def admin_user
    return if current_user.admin?
    flash[:danger] = "アクセス権限がありません"
    url = request.referer
    url.present? ? redirect_to(url) : redirect_to(calendar_index_url)
  end
end
