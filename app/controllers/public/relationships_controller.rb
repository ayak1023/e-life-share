class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find(params[:user_id]) # ここで@userを設定
    current_user.follow(@user)
    respond_to do |format|
      format.js # create.js.erbを呼び出す
    end
  end

  def destroy
    @user = User.find(params[:user_id]) # ここで@userを設定
    current_user.unfollow(@user)
    respond_to do |format|
      format.js # destroy.js.erbを呼び出す
    end
  end

  def followings
    @user = User.find(params[:user_id])
    @users = @user.followings
  end

  def followers
    @user = User.find(params[:user_id])
    @users = @user.followers
  end
end