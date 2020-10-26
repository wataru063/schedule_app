class ConstructionsController < ApplicationController
  before_action :logged_in_user
  before_action :set_construction, only: [:show, :edit, :update, :destroy]
  before_action :set_constructions, only: [:index, :search, :create, :edit, :update, :destroy]
  before_action :set_construction_select, only: [:new, :create, :edit, :update]
  before_action :belong_to_construction_department, only: [:new, :create]
  before_action :user_in_charge, only: [:edit, :update, :destroy]

  def index; end

  def search
    if params[:export_csv]
      csv = Construction.search(search_params).order(@sort_column + ' ' + sort_direction)
      send_data to_csv_construction(csv), filename: "#{Time.current.strftime('%Y%m%d')}工事一覧.csv"
    else
      render :index
    end
  end

  def show
    @comment = Comment.new
    url = request.referer
    respond_to do |format|
      format.html { url.present? ? redirect_to(url) : redirect_to(constructions_url) }
      format.js
    end
  end

  def new
    @construction = Construction.new
    url = request.referer
    respond_to do |format|
      format.html { url.present? ? redirect_to(url) : redirect_to(constructions_url) }
      format.js
    end
  end

  def create
    @construction = Construction.new(construction_params)
    @start_at_date = get_date(@construction, "start")
    @end_at_date = get_date(@construction, "end")
    context = current_user.admin? ? :admin : ""
    if @construction.save(context: context)
      flash[:success] = "#{@construction.name} を登録しました。"
      respond_to do |format|
        format.js { render ajax_redirect_to(calendar_index_url) }
      end
    end
  end

  def edit; end

  def update
    if @construction.update_attributes(construction_params)
      flash[:success] = "登録情報を変更いたしました。"
      redirect_to constructions_url
    else
      render :edit
    end
  end

  def destroy
    @construction.destroy
    flash[:success] = "#{@construction.name} を削除しました。"
    request.referer.present? ? redirect_to(request.referer) : redirect_to(constructions_url)
  end

  private

  def set_construction
    @construction = Construction.find(params[:id])
  end

  def construction_params
    params.require(:construction).
      permit(:id, :name, :status_id, :notice, :facility_id, :oil_id, :user_id,
             :start_at, :end_at, :start_at_date, :end_at_date)
  end

  def search_params
    params.permit(:id, :name, :status_id, :notice, :facility_id, :oil_id, :user_id,
                  :start_at, :end_at, :start_at_date, :end_at_date)
  end

  def belong_to_construction_department
    return if current_user.admin?
    return unless current_user.category_id == 6
    flash[:danger] = "アクセス権限がありません"
    request.referer.present? ? redirect_to(request.referer) : redirect_to(calendar_index_url)
  end

  def user_in_charge
    return if current_user.admin?
    return if Construction.find(params[:id]).user.id == current_user.id
    flash[:danger] = "アクセス権限がありません"
    request.referer.present? ? redirect_to(request.referer) : redirect_to(calendar_index_url)
  end
end
