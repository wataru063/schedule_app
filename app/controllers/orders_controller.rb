class OrdersController < ApplicationController
  def index
    @status = %w(実行検討中 工事準備中 工事中 工事完了)
    reset_params("arrive")     if params[:arrive_at_date].blank?
    set_time(params, "arrive") if params[:arrive_at_date].present?
    sort_column = params[:column].presence || 'arrive_at'
    @order = Order.search(search_params).
      order(sort_column + ' ' + sort_direction).
      paginate(page: params[:page], per_page: 7)
    @search_params = search_params
    if params[:export_csv]
      @order_csv = Order.search(search_params).
        order(sort_column + ' ' + sort_direction)
      send_data to_csv_order(@order_csv), filename: "#{Time.current.strftime('%Y%m%d')}オーダー一覧.csv"
    end
  end

  def new
    @order = Order.new
  end

  def oil
    oil_id = Facility.find(params[:facility_id]).oils.ids
    @oils = Oil.where(id: oil_id).pluck(:id, :name).to_h.to_json
    p @oils
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

  private

  def order_params
    params.
      require(:order).
      permit(:id, :name, :shipment, :company_name, :unit, :facility_id, :oil_id, :user_id,
             :quantity, :arrive_at, :arrive_at_date)
  end

  def search_params
    params.permit(:id, :name, :company_name, :shipment, :unit, :facility_id, :oil_id,
                  :quantity, :arrive_at, :arrive_at_date)
  end
end
