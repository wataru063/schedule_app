class CalendarController < ApplicationController
  def index
    set_construction
    Facility.all.each do |f|
      @construction[f.id].each do |c|
      end
    end
    @facilities = Facility.all
  end

  def show
    @facility = Facility.all
    @facility_id = params[:facility_id]
  end

  private

    def set_construction
      @construction = []
      Facility.all.each do |f|
        oil_ids = f.oils.ids
        @construction[f.id] = Construction.where(facility_id: f.id,
                                                 start_at: Time.current.beginning_of_week - 1.day..
                                                           Time.current.since(14.days).end_of_day) +
                              Construction.where(facility_id: nil, oil_id: oil_ids,
                                                 start_at: Time.current.beginning_of_week - 1.day..
                                                           Time.current.since(14.days).end_of_day)
      end
    end
end
