class SessionsController < ApplicationController
  before_action :logged_in_user, only: [:destroy]
  before_action :logged_in_user_for_top, only: [:new, :create]

  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      flash[:success] = 'ログインに成功しました。'
      log_in @user
      remember @user
      redirect_back_or calendar_index_url
    else
      flash.now[:danger] = 'ログインに失敗しました。'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
