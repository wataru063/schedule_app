class ConstructionsController < ApplicationController
  before_action :logged_in_user
  before_action :set_construction, only: [:show, :edit, :update, :destroy]
  before_action :belong_to_construction_department, only: [:new, :create]
  before_action :user_in_charge, only: [:edit, :update, :destroy]

  def index
    set_params_for_search
    sort_column = params[:column].presence || 'start_at'
    @constructions = Construction.search(search_params).order(sort_column + ' ' + sort_direction).
      paginate(page: params[:page], per_page: 7)
    @search_params = search_params
    @construction  = Construction.first
    @comment = Comment.new
  end

  def search
    set_params_for_search
    reset_time("start")
    reset_time("end")
    set_time(params, "start")
    set_time(params, "end")
    sort_column = params[:column].presence || 'start_at'
    if params[:export_csv]
      csv = Construction.search(search_params).order(sort_column + ' ' + sort_direction)
      send_data to_csv_construction(csv), filename: "#{Time.current.strftime('%Y%m%d')}工事一覧.csv"
    else
      @constructions = Construction.search(search_params).order(sort_column + ' ' + sort_direction).
        paginate(page: params[:page], per_page: 7)
      @search_params = search_params
      render :index
    end
  end

  def show
    @comment = Comment.new
  end

  def new
    set_select_params
    @construction = Construction.new
  end

  def create
    set_time(params[:construction], "start")
    set_time(params[:construction], "end")
    @construction = Construction.new(construction_params)
    if @construction.save
      flash[:success] = "#{@construction.name} を登録しました。"
      url = request.referer
      url.present? ? redirect_to(url) : redirect_to(calendar_index_url)
    else
      render 'calendar/index'
    end
  end

  def edit
    set_select_params
    @oils = @construction.facility.present? ? @construction.facility.oils : @all_oils
    @start_at_date = get_date(@construction, "start")
    @end_at_date = get_date(@construction, "end")
  end

  def update
    set_time(params[:construction], "start")
    set_time(params[:construction], "end")
    if @construction.update_attributes(construction_params)
      flash[:success] = "登録情報を変更いたしました。"
      redirect_to constructions_url
    else
      set_select_params
      @start_at_date = get_date(@construction, "start")
      @end_at_date = get_date(@construction, "end")
      flash[:danger] = "登録情報変更に失敗しました。"
      render :edit
    end
  end

  def destroy
    @construction.destroy
    flash[:success] = "#{@construction.name} を削除しました。"
    url = request.referer
    url.present? ? redirect_to(url) : redirect_to(constructions_url)
  end

  private

  def set_construction
    @construction = Construction.find(params[:id])
  end

  def construction_params
    params.require(:construction).
      permit(:name, :status_id, :notice, :facility_id, :oil_id, :user_id,
             :start_at, :end_at, :start_at_date, :end_at_date)
  end

  def search_params
    params.permit(:id, :status_id, :facility_id, :oil_id, :start_at, :end_at,
                  :start_at_date, :end_at_date)
  end

  def set_select_params
    @status = Status.all
    @category = Category.all
    @all_facilities = Facility.all
    @facility = params[:facility_id] if params[:facility_id].present?
    @all_oils = Oil.all
    @oils = Facility.find(params[:facility_id]).oils if params[:facility_id].present?
    @user = User.all
    @start_at_date = params[:date] if params[:date].present?
  end

  def set_params_for_search
    @status = Status.all
    @const_facil_id = Construction.select(:facility_id).distinct
    @const_oil_id = Construction.select(:oil_id).distinct
  end

  def belong_to_construction_department
    if current_user.category_id == 6
      flash[:danger] = "アクセス権限がありません"
      url = request.referer
      url.present? ? redirect_to(url) : redirect_to(calendar_index_url)
    end
  end

  def user_in_charge
    unless Construction.find(params[:id]).user.id == current_user.id
      flash[:danger] = "アクセス権限がありません"
      url = request.referer
      url.present? ? redirect_to(url) : redirect_to(calendar_index_url)
    end
  end
end
