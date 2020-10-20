class Admin::HomeController < ApplicationController
  before_action :admin_user

  def top; end
end
