class OrdersController < ApplicationController
  before_action :logged_in_user
  before_action :set_order_times, only: [:create, :update]
  before_action :set_order,  only: [:show, :edit, :update, :destroy]
  before_action :set_orders, only: [:index, :search]
  before_action :set_order_select, only: [:new, :edit, :create, :update]
  before_action :belong_to_supply_and_demand_management
  before_action :user_in_charge, only: [:edit, :update, :destroy]

  def index; end

  def search
    if params[:export_csv]
      @order = Order.search(search_params).order(@sort_column + ' ' + sort_direction)
      send_data to_csv_order(@order), filename: "#{Time.current.strftime('%Y%m%d')}オーダー一覧.csv"
    else
      render :index
    end
  end

  def new
    @arrive_at_date = params[:date].present? ? params[:date] : Date.tomorrow
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @arrive_at_date = get_date(@order, "arrive")
    if @order.save
      flash[:success] = "#{@order.name}のオーダーを登録しました。"
      respond_to do |format|
        format.js { render ajax_redirect_to(calendar_index_url) }
      end
    end
  end

  def show
    url = request.referer
    respond_to do |format|
      format.html { url.present? ? redirect_to(url) : redirect_to(calendar_index_url) }
      format.js
    end
  end

  def edit; end

  def update
    @arrive_at_date = get_date(@order, "arrive")
    if @order.update_attributes(order_params)
      flash[:success] = "登録情報を変更いたしました。"
      redirect_to calendar_index_url
    else
      render :edit
    end
  end

  def destroy
    @order.destroy
    flash[:success] = "#{@order.name} を削除しました。"
    request.referer.present? ? redirect_to(request.referer) : redirect_to(orders_url)
  end

  private

  def set_order
    @order = Order.find(params[:id])
    @arrive_at_date = get_date(@order, "arrive") if action_name == "edit"
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

  def belong_to_supply_and_demand_management
    return if current_user.admin?
    return if current_user.category_id == 6
    flash[:danger] = "アクセス権限がありません"
    request.referer.present? ? redirect_to(request.referer) : redirect_to(orders_url)
  end

  def user_in_charge
    return if current_user.admin?
    return if Order.find(params[:id]).user.id == current_user.id
    flash[:danger] = "アクセス権限がありません"
    request.referer.present? ? redirect_to(request.referer) : redirect_to(calendar_index_url)
  end
end
