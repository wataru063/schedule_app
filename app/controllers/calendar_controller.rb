class CalendarController < ApplicationController
  def index
    @facilities = Facility.all
  end

  def show
    @facility = Facility.all
    @facility_id = params[:facility_id]
  end
end
