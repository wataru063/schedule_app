module UsersHelper
require 'csv'
  # export to csv
  def to_csv_user(users)
    CSV.generate do |csv|
      columns_ja = %w(No. ユーザー名 所属部署 メールアドレス)
      columns = %w(no name category_name email)
      csv << columns_ja
      no = 1
      users.each do |u|
        con_attr = u.attributes
        con_attr["no"] = no
        con_attr["name"] = u.name
        con_attr["category_name"] = u.category.name
        con_attr["email"] = u.email
        csv << con_attr.values_at(*columns)
        no += 1
      end
    end
  end

  def set_params_user_show
    @status = Status.all
    @shipment = Shipment.all
    @orders = @user.orders.order(arrive_at: :asc).page(params[:page]).per(5)
    if @user.category_id == 6
      oil_ids = []
      @user.orders.each do |order|
        oil_ids << order.oil.id
      end
      oil_ids.uniq!.sort! { |a, b| a.to_i <=> b.to_i }
      @orders_constructions = Construction.where(oil_id: oil_ids).order(start_at: :asc).
        page(params[:page]).per(5)
    end
    @constructions = @user.constructions.order(start_at: :asc).page(params[:page]).per(5)
  end
end
