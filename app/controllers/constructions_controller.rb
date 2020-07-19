class ConstructionsController < ApplicationController
  def new
    @construction = Construction.new
  end

  def create
    if params[:construction][:start_at_date].present?
      start_date = params[:construction][:start_at_date].split("-")
      params[:construction]["start_at(1i)"] = start_date[0]
      params[:construction]["start_at(2i)"] = start_date[1]
      params[:construction]["start_at(3i)"] = start_date[2]
    end
    if params[:construction][:end_at_date].present?
      end_date = params[:construction][:end_at_date].split("-")
      params[:construction]["end_at(1i)"] = end_date[0]
      params[:construction]["end_at(2i)"] = end_date[1]
      params[:construction]["end_at(3i)"] = end_date[2]
    end
    @construction = Construction.new(construction_params)
    if @construction.save
      flash[:success] = "#{@construction.name} を登録しました。"
      redirect_to construction_path
    else
      render :new
    end
  end

  private

  def construction_params
    params.
      require(:construction).
      permit(:name, :status, :notice, :facility_id, :oil_id, :category_id, :user_id,
             :start_at, :end_at, :start_at_date, :end_at_date)
  end
end
