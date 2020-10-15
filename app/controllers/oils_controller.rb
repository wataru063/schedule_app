class OilsController < ApplicationController
  def select
    if params[:facility_id].present?
      oil_id = Facility.find(params[:facility_id]).oils.ids
      @oil_selects = Oil.where(id: oil_id).pluck(:id, :name).to_h.to_json
    else
      @oil_selects = Oil.all.pluck(:id, :name).to_h.to_json
    end
  end
end
