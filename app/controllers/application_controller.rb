class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ApplicationHelper
  include SessionsHelper
  include ConstructionsHelper
  include OrdersHelper
  include EventsHelper
end
