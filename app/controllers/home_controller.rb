class HomeController < ApplicationController
  before_action :logged_in_user_for_top

  def top
  end
end
