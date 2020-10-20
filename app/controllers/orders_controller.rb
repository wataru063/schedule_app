class OrdersController < ApplicationController
  before_action :logged_in_user
  before_action :set_oil, only: [:show, :edit, :update, :destroy]
  before_action :belong_to_supply_and_demand_management
  before_action :user_in_charge, only: [:edit, :update, :destroy]

  def index
    set_params_for_search
    @order = Order.first
  end

  def search
    set_params_for_search
    reset_time("arrive")
    set_time(params, "arrive")
    if params[:export_csv]
      @order = Order.search(search_params).order(@sort_column + ' ' + sort_direction)
      send_data to_csv_order(@order), filename: "#{Time.current.strftime('%Y%m%d')}オーダー一覧.csv"
    else
      render :index
    end
  end

  def new
    set_select_params
    @arrive_at_date = params[:date] if params[:date].present?
    @order = Order.new
  end

  def create
    set_time(params[:order], "arrive")
    @order = Order.new(order_params)
    if @order.save
      flash[:success] = "#{@order.name}のオーダーを登録しました。"
      respond_to do |format|
        format.js { render ajax_redirect_to(calendar_index_url) }
      end
    end
  end

  def show
    respond_to do |format|
      format.html { redirect_to edit_order_url(@order) }
      format.js
    end
  end

  def edit
    set_select_params
    @arrive_at_date = get_date(@order, "arrive")
  end

  def update
    set_time(params[:order], "arrive")
    if @order.update_attributes(order_params)
      flash[:success] = "登録情報を変更いたしました。"
      redirect_to orders_url
    else
      set_select_params
      @arrive_at_date = get_date(@order, "arrive")
      render :edit
    end
  end

  def destroy
    @order.destroy
    flash[:success] = "#{@order.name} を削除しました。"
    url = request.referer
    url.present? ? redirect_to(url) : redirect_to(orders_url)
  end

  private

  def set_oil
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).
      permit(:id, :name, :shipment_id, :company_name, :unit, :facility_id, :oil_id, :user_id,
             :quantity, :arrive_at, :arrive_at_date)
  end

  def search_params
    params.permit(:id, :name, :company_name, :shipment_id, :unit, :facility_id, :oil_id,
                  :quantity, :arrive_at, :arrive_at_date)
  end

  def set_select_params
    @shipment = Shipment.all
    @all_facilities = Facility.all
    @facility = params[:facility_id] if params[:facility_id].present?
    @oils = Facility.find(params[:facility_id]).oils if params[:facility_id].present?
    @user = User.all
  end

  def set_params_for_search
    @shipment = Shipment.all
    @name = Order.select(:name).distinct
    @company_name = Order.select(:company_name).distinct
    @facility_id = Order.select(:facility_id).distinct
    @oil_id = Order.select(:oil_id).distinct
    @sort_column = params[:column].presence || 'arrive_at'
    @orders = Order.search(search_params).order(@sort_column + ' ' + sort_direction).
      page(params[:page]).per(7)
    @search_params = search_params
  end

  def belong_to_supply_and_demand_management
    return if current_user.category_id == 6
    flash[:danger] = "アクセス権限がありません"
    url = request.referer
    url.present? ? redirect_to(url) : redirect_to(calendar_index_url)
  end

  def user_in_charge
    return if Order.find(params[:id]).user.id == current_user.id
    flash[:danger] = "アクセス権限がありません"
    url = request.referer
    url.present? ? redirect_to(url) : redirect_to(calendar_index_url)
  end
end
