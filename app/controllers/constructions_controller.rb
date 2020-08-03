class ConstructionsController < ApplicationController
  def index
    @status = %w(実行検討中 工事準備中 工事中 工事完了)
    reset_params("start")     if params[:start_at_date].blank?
    reset_params("end")       if params[:end_at_date].blank?
    set_time(params, "start") if params[:start_at_date].present?
    set_time(params, "end")   if params[:end_at_date].present?
    sort_column = params[:column].presence || 'start_at'
    @construction = Construction.search(search_params).
      order(sort_column + ' ' + sort_direction).
      paginate(page: params[:page], per_page: 7)
    @search_params = search_params
    if params[:export_csv]
      @construction_csv = Construction.search(search_params).
        order(sort_column + ' ' + sort_direction)
      send_data to_csv_construction(@construction_csv), filename: "#{Time.current.strftime('%Y%m%d')}工事一覧.csv"
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
end
