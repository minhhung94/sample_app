class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :load_user, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.where(activated: FILL_IN).paginate(page: params[:page],
      per_page: Settings.users.index.per_page)
  end

  def new
    @user = User.new
  end

  def show; end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".check_email"
      redirect_to root_url
    else
      flash.now[:danger] = t ".create_fail"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = t ".success"
      redirect_to @user
    else
      flash[:danger] = t ".fail"
      render "edit"
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".del_success"
    else
      flash[:danger] = t ".message_not_delete"
    end
    redirect_to users_url
  end

  private
  def user_params
    params.require(:user).permit(:name, :email,
      :password, :password_confirmation)
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t ".please_login"
    redirect_to login_url
  end

  def correct_user
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "users.show.notice_error"
    redirect_to root_url
  end
end
