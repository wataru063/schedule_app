class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :show, :destroy]
  before_action :correct_user,   only: [:edit, :update, :destroy]
  before_action :logged_in_user_for_top, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = '登録しました。'
      redirect_to calendar_index_url
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    set_params
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "登録情報を変更いたしました。"
      redirect_to @user
    else
      set_params
      flash[:danger] = "登録情報変更に失敗しました。"
      render :show
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = "#{@user.name}を削除しました。"
    redirect_to root_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation, :category_id)
    end

    def set_params
      @status = Status.all
      @shipment = Shipment.all
      oil_ids = []
      @orders = @user.orders.order(arrive_at: :asc).paginate(page: params[:page], per_page: 6)
      if @user.category_id == 6
        @user.orders.each do |order|
          oil_ids << order.oil.id
        end
        oil_ids.uniq!.sort! { |a, b| a.to_i <=> b.to_i }
        @orders_constructions = Construction.where(oil_id: oil_ids).
          order(start_at: :asc).paginate(page: params[:page], per_page: 6)
      end
      @constructions = @user.constructions.order(start_at: :asc).
        paginate(page: params[:page], per_page: 6)
    end
end
