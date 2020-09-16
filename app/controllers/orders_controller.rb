class OrdersController < ApplicationController
  before_action :logged_in_user
  before_action :belong_to_supply_and_demand_management

  def index
    set_select_params
    sort_column = params[:column].presence || 'arrive_at'
    @order = Order.search(search_params).
      order(sort_column + ' ' + sort_direction).
      paginate(page: params[:page], per_page: 7)
    @search_params = search_params
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
      @order = Order.search(search_params).
        order(sort_column + ' ' + sort_direction).
        paginate(page: params[:page], per_page: 7)
      @search_params = search_params
      render template: 'orders/index'
    end
  end

  def show
    @order = Order.find(params[:id])
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
end
