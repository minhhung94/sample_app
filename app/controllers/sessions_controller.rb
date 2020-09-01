class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate(params[:session][:password])
      remembe_me user, params
      redirect_back_or user
    else
      flash.now[:danger] = t ".error"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def remembe_me user, params
    log_in user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
  end
end
