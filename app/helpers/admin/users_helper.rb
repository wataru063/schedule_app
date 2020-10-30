module Admin::UsersHelper
  def admin_respond_to_html_js
    respond_to do |format|
      format.html { redirect_to admin_top_url }
      format.js
    end
  end
end
