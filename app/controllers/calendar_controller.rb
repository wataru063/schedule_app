class CalendarController < ApplicationController
  before_action :logged_in_user

  def index
    @comment = Comment.new
    set_construction
    @facility = Facility.all
  end

  def show
    @comment = Comment.new
    @facility = Facility.all
    @facility_id = params[:facility_id]
  end

  private

    def set_construction
      @const_event = []
      Facility.all.each do |f|
        oil_ids = f.oils.ids
        @const_event[f.id] = Construction.where(facility_id: f.id,
                                                start_at: Time.current.beginning_of_week - 1.day..
                                                          Time.current.since(14.days).end_of_day) +
                             Construction.where(facility_id: nil, oil_id: oil_ids,
                                                start_at: Time.current.beginning_of_week - 1.day..
                                                          Time.current.since(14.days).end_of_day)
      end
    end
end
