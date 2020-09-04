class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, :check_expiration , only: [:edit, :update]

  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "flash.pwd_reset.info"
      redirect_to root_url
    else
      flash.now[:danger] = t "flash.pwd_reset.danger.not_found"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, t("flash.pwd_reset.danger.cant_blank"))
      render "edit"
    elsif @user.update_attributes(user_params)
      login @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = t "flash.pwd_reset.success"
      redirect_to @user
    else
      flash.now[:danger] = t "flash.pwd_reset.danger.failed_update"
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by(email: params[:email])
    return if @user

    flash[:warning] = t "flash.pwd_reset.danger.not_found"
    redirect_to root_url
  end

  # Confirms a valid user.
  def valid_user
    return if @user.activated? && @user.authenticated?(:reset, params[:id])

    flash.now[:danger] = t "flash.pwd_reset.danger.not_valid_user"
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash.now[:danger] = t "flash.pwd_reset.danger.expired"
    redirect_to new_password_reset_url
  end
end
