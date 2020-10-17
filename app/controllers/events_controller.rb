class EventsController < ApplicationController
  def index
    @facility_id = params[:facility_id].present? ? params[:facility_id] : @facility_id
    @events = create_event(@facility_id, current_user)
    respond_to do |format|
      format.json do
        render json: @events.to_json
      end
    end
  end

  def show
    @facility_id = params[:facility_id].present? ? params[:facility_id] : @facility_id
    @events = create_event(@facility_id, current_user)
    respond_to do |format|
      format.json do
        render json: @events.to_json
      end
    end
  end
end
