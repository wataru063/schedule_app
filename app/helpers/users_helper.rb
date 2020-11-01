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
    @constructions = @user.constructions.order(start_at: :asc).page(params[:page]).per(5)
    @comments = @user.comments.order(construction_id: :asc).page(params[:page]).per(5)
  end
end
