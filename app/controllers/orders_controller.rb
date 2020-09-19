class OrdersController < ApplicationController
  before_action :logged_in_user
  before_action :belong_to_supply_and_demand_management
  before_action :user_in_charge, only: [:edit, :update, :destroy]

  def index
    set_select_params
    sort_column = params[:column].presence || 'arrive_at'
    @orders = Order.search(search_params).
      order(sort_column + ' ' + sort_direction).
      paginate(page: params[:page], per_page: 7)
    @search_params = search_params
    @order = Order.first
  end

  def search
    set_select_params
    reset_time("arrive")
    set_time(params, "arrive")
    sort_column = params[:column].presence || 'arrive_at'
    if params[:export_csv]
      @order = Order.search(search_params).order(sort_column + ' ' + sort_direction)
      send_data to_csv_order(@order), filename: "#{Time.current.strftime('%Y%m%d')}オーダー一覧.csv"
    else
      @orders = Order.search(search_params).
        order(sort_column + ' ' + sort_direction).
        paginate(page: params[:page], per_page: 7)
      @search_params = search_params
      render template: 'orders/index'
    end
  end

  def new
    @order = Order.new
    if params[:facility_id].present?
      oil_id = Facility.find(params[:facility_id]).oils.ids
      @oils = Oil.where(id: oil_id).pluck(:id, :name).to_h.to_json
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    set_time(params[:order], "arrive")
    @order = Order.new(order_params)
    if @order.save
      flash[:success] = "#{@order.name}のオーダーを登録しました。"
      redirect_to new_order_path
    else
      render :new
    end
  end

  def oil
    oil_id = Facility.find(params[:facility_id]).oils.ids
    @oils = Oil.where(id: oil_id).pluck(:id, :name).to_h.to_json
  end

  def show
    @order = Order.find(params[:id])
  end

  def edit
    set_select_params_all
    @order = Order.find(params[:id])
    @arrive_at_date = get_date(@order, "arrive")
  end

  def update
    set_time(params[:order], "arrive")
    @order = Order.find(params[:id])
    if @order.update_attributes(order_params)
      flash[:success] = "登録情報を変更いたしました。"
      redirect_to orders_url
    else
      set_select_params_all
      @arrive_at_date = get_date(@order, "arrive")
      flash[:danger] = "登録情報変更に失敗しました。"
      render :edit
    end
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    flash[:success] = "#{@order.name} を削除しました。"
    if url = request.referer
      redirect_to url
    else
      redirect_to orders_url
    end
  end

  private

  def order_params
    params.
      require(:order).
      permit(:id, :name, :shipment_id, :company_name, :unit, :facility_id, :oil_id, :user_id,
             :quantity, :arrive_at, :arrive_at_date)
  end

  def search_params
    params.permit(:id, :name, :company_name, :shipment_id, :unit, :facility_id, :oil_id,
                  :quantity, :arrive_at, :arrive_at_date)
  end

  def set_select_params_all
    @shipment = []
    2.times do |n|
      @shipment << Shipment.find(n + 1)
    end
    @facility = Facility.all
    @oil = Oil.all
    @user = User.all
  end

  def set_select_params
    @shipment = Shipment.all
    @name = Order.select(:name).distinct
    @company_name = Order.select(:company_name).distinct
    @facility_id = Order.select(:facility_id).distinct
    @oil_id = Order.select(:oil_id).distinct
  end

  def belong_to_supply_and_demand_management
    unless current_user.category_id == 6
      flash[:danger] = "アクセス権限がありません"
      if url = request.referer
        redirect_to url
      else
        redirect_to calendar_index_url
      end
    end
  end

  def user_in_charge
    unless Order.find(params[:id]).user.id == current_user.id
      flash[:danger] = "アクセス権限がありません"
      if url = request.referer
        redirect_to url
      else
        redirect_to calendar_index_url
      end
    end
  end
end
