class ConstructionsController < ApplicationController
  def index
    set_select_params
    @construction = Construction.paginate(page: params[:page], per_page: 7)
    @search_params = search_params
  end

  def search
    set_select_params
    reset_time("start")
    reset_time("end")
    set_time(params, "start")
    set_time(params, "end")
    sort_column = params[:column].presence || 'start_at'
    if params[:export_csv]
      csv_data = Construction.search(search_params).order(sort_column + ' ' + sort_direction)
      send_data to_csv_construction(csv_data), filename: "#{Time.current.strftime('%Y%m%d')}工事一覧.csv"
    else
      @construction = Construction.search(search_params).
        order(sort_column + ' ' + sort_direction).
        paginate(page: params[:page], per_page: 7)
      @search_params = search_params
      render template: 'constructions/index'
    end
  end

  def new
    @construction = Construction.new
  end

  def create
    set_time(params[:construction], "start")
    set_time(params[:construction], "end")
    @construction = Construction.new(construction_params)
    if @construction.save
      flash[:success] = "#{@construction.name} を登録しました。"
      redirect_to new_construction_path
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

  def search_params
    params.permit(:id, :status, :facility_id, :oil_id, :start_at, :end_at,
                  :start_at_date, :end_at_date)
  end

  def set_select_params
    @status = Status.all
    @facility_id = Construction.select(:facility_id).distinct
    @oil_id = Construction.select(:oil_id).distinct
  end
end
