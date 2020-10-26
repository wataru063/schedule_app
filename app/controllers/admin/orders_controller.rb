class Admin::OrdersController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user
  before_action :set_order_times, only: [:create, :update]
  before_action :set_order,  only: [:show, :edit, :update, :destroy]
  before_action :set_orders, only: [:index, :search, :create, :edit, :update, :destroy]
  before_action :set_order_select, only: [:new, :create, :edit, :update]

  def index
    respond_to do |format|
      format.html { redirect_to admin_top_url }
      format.js
    end
  end

  def search
    respond_to do |format|
      format.html do
        if search_params.present?
          csv = Order.search(search_params).order(@sort_column + ' ' + sort_direction)
          send_data to_csv_order(csv), filename: "#{Time.current.strftime('%Y%m%d')}オーダー一覧.csv"
        else
          redirect_to admin_top_url
        end
      end
      format.js
    end
  end

  def new
    @arrive_at_date = params[:date].present? ? params[:date] : Date.tomorrow
    @order = Order.new
    respond_to do |format|
      format.html { redirect_to admin_top_url }
      format.js
    end
  end

  def create
    @order = Order.new(order_params)
    @arrive_at_date = get_date(@order, "arrive")
    @success = @order.save ? true : false
  end

  def edit
    @arrive_at_date = get_date(@order, "arrive")
    respond_to do |format|
      format.html { redirect_to admin_top_url }
      format.js
    end
  end

  def update
    @arrive_at_date = get_date(@order, "arrive")
    @success = @order.update_attributes(order_params) ? true : false
  end

  def destroy
    @order.destroy
    @count = Order.search(search_params).count
  end

  private

  def set_order
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
end
