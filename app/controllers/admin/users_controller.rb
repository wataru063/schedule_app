class Admin::UsersController < ApplicationController
  before_action :admin_user
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :set_users, except: [:new, :show]

  def index; end

  def search
    respond_to do |format|
      format.html do
        csv = User.search(search_params).order(@sort_column + ' ' + sort_direction)
        send_data to_csv_user(csv), filename: "#{Time.current.strftime('%Y%m%d')}ユーザー一覧.csv"
      end
      format.js
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @success = @user.save ? true : false
  end

  def show
    set_params
  end

  def update
    @success = @user.save ? true : false
  end

  def destroy
    @user.destroy
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :category_id)
    end

    def search_params
      params.permit(:name, :email, :password, :password_confirmation, :category_id)
    end

    def set_users
      @categories = Category.all
      @sort_column = params[:column].presence || 'category_id'
      @users = User.search(search_params).order(@sort_column + ' ' + sort_direction).
        page(params[:page]).per(13)
      @search_params = search_params
    end

    def set_params
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
