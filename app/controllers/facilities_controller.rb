class FacilitiesController < ApplicationController
  before_action :logged_in_user
  # TODO admin user only accessable

  def new
    @facility = Facility.new
    @facility.relate_to_oils.build
  end

  def create
    @facility = Facility.new(facility_params)
    # TODO gemを使わずに書く方法
    #   @facilityoil = FacilityOil.new
    #   @facilityoil.facility_id = params[:facility_id]
    #   @facilityoil.oil_id = params[:oil_id]
    #   params[].each do |param|
    #   end
    if @facility.save
      flash[:success] = "#{@facility.name} を登録しました。"
      redirect_to @facility
    else
      render :new
    end
  end

  private

    def facility_params
      params.
        require(:facility).
        permit(:name, relate_to_oils_attributes: [:facility_id, :oil_id, :id])
    end
end
