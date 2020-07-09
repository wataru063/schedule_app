class FacilitiesController < ApplicationController
  def new
    @facility = Facility.new
    @facility.relate_to_oils.build
  end

  def create
    @facility = Facility.new(facility_params)
#    render plain: params.inspect
#    render plain: params[:facility][:oil_ids].inspect
    if @facility.save
      flash[:success] = "#{@facility.name} を登録しました。"
      redirect_to facility_path
    else
      flash.now[:danger] = '登録に失敗しました。'
      render :new
    end
  end

  private

    def facility_params
      params.
        require(:facility).
        permit(:name, relate_to_oils_attributes: [:facility_id, :oil_id])
    end
end
