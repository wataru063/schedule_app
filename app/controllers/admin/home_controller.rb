class Admin::HomeController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user

  def top; end
end
