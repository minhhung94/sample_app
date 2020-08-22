class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :load_create_user, only: :create
  before_action :load_destroy_user, only: :destroy

  def create
    current_user.follow(@user)
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def destroy
    @user = @relationship.followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  private
  def load_create
    @user = User.find_by id: params[:followed_id]
    return if @user

    flash[:danger] = t "controller.relationships.fail"
    redirect_to root_url
  end

  def load_destroy
    @relationship = Relationship.find_by id: params[:id]
    return if @user

    flash[:danger] = t "controller.relationships.fail"
    redirect_to root_url
  end
end
