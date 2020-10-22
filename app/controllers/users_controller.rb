class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :show, :destroy]
  before_action :correct_user,   only: [:edit, :update, :destroy]
  before_action :logged_in_user_for_top, only: [:new, :create]
  before_action :forbid_guest_user, only: [:edit, :update, :destroy]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

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
    set_params_user_show
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit; end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "登録情報を変更いたしました。"
      redirect_to @user
    else
      set_params_user_show
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

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :category_id)
    end

    def forbid_guest_user
      return unless @user.email == "guestuser@example.com"
      flash[:notice] = "テストユーザーのため編集できません"
      request.referer.present? ? redirect_to(request.referer) : redirect_to(@user)
    end
end
