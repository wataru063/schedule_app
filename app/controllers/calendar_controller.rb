class CalendarController < ApplicationController
  def index
    @facility = Facility.all
    @facility_id = params[:facility_id]
  end
end
