class ConstructionsController < ApplicationController
  before_action :logged_in_user
  before_action :belong_to_construction_department, only: [:new, :create]
  before_action :user_in_charge, only: [:edit, :update, :destroy]

  def index
    set_select_params_for_index
    sort_column = params[:column].presence || 'start_at'
    @constructions = Construction.search(search_params).
      order(sort_column + ' ' + sort_direction).
      paginate(page: params[:page], per_page: 7)
    @search_params = search_params
    @construction  = Construction.first
    @comment = Comment.new
  end

  def search
    set_select_params_for_index
    reset_time("start")
    reset_time("end")
    set_time(params, "start")
    set_time(params, "end")
    sort_column = params[:column].presence || 'start_at'
    if params[:export_csv]
      csv = Construction.search(search_params).order(sort_column + ' ' + sort_direction)
      send_data to_csv_construction(csv), filename: "#{Time.current.strftime('%Y%m%d')}工事一覧.csv"
    else
      @constructions = Construction.search(search_params).
        order(sort_column + ' ' + sort_direction).
        paginate(page: params[:page], per_page: 7)
      @search_params = search_params
      render :index
    end
  end

  def show
    @construction = Construction.find(params[:id])
    @comment = Comment.new
      respond_to do |format|
        format.html
        format.js
      end
  end

  def new
    set_select_params_for_new
    @construction = Construction.new
  end

  def create
    set_time(params[:construction], "start")
    set_time(params[:construction], "end")
    @construction = Construction.new(construction_params)
    if @construction.save
      flash[:success] = "#{@construction.name} を登録しました。"
      if url = request.referer
        redirect_to url
      else
        redirect_to calendar_index_url
      end
    else
      render 'calendar/index'
    end
  end

  def edit
    set_select_params_for_new
    @construction = Construction.find(params[:id])
    @start_at_date = get_date(@construction, "start")
    @end_at_date = get_date(@construction, "end")
  end

  def update
    set_time(params[:construction], "start")
    set_time(params[:construction], "end")
    @construction = Construction.find(params[:id])
    if @construction.update_attributes(construction_params)
      flash[:success] = "登録情報を変更いたしました。"
      redirect_to constructions_url
    else
      set_select_params_for_new
      @start_at_date = get_date(@construction, "start")
      @end_at_date = get_date(@construction, "end")
      flash[:danger] = "登録情報変更に失敗しました。"
      render :edit
    end
  end

  def destroy
    @construction = Construction.find(params[:id])
    @construction.destroy
    flash[:success] = "#{@construction.name} を削除しました。"
    if url = request.referer
      redirect_to url
    else
      redirect_to constructions_url
    end
  end

  private

  def construction_params
    params.
      require(:construction).
      permit(:name, :status_id, :notice, :facility_id, :oil_id, :user_id,
             :start_at, :end_at, :start_at_date, :end_at_date)
  end

  def search_params
    params.permit(:id, :status_id, :facility_id, :oil_id, :start_at, :end_at,
                  :start_at_date, :end_at_date)
  end

  def set_select_params_for_new
    @status = []
    @category = []
    2.times do |n|
      @status << Status.find(n + 1)
    end
    @facility = Facility.all
    @oil = Oil.all
    @selected_oils = Facility.find(params[:facility_id]).oils if params[:facility_id].present?
    @user = User.all
    @start_at_date = params[:date] if params[:date].present?
  end

  def set_select_params_for_index
    @status = Status.all
    @const_facil_id = Construction.select(:facility_id).distinct
    @const_oil_id = Construction.select(:oil_id).distinct
  end

  def belong_to_construction_department
    if current_user.category_id == 6
      flash[:danger] = "アクセス権限がありません"
      if url = request.referer
        redirect_to url
      else
        redirect_to calendar_index_url
      end
    end
  end

  def user_in_charge
    unless Construction.find(params[:id]).user.id == current_user.id
      flash[:danger] = "アクセス権限がありません"
      if url = request.referer
        redirect_to url
      else
        redirect_to calendar_index_url
      end
    end
  end
end
