class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    user = User.find(params[:user_id])
    current_user.follow(user)

    # フォロー数を取得
    followings_count = current_user.followings.count
    followers_count = user.followers.count

    respond_to do |format|
      format.html { redirect_to request.referer }
      format.json { render json: { followings_count: followings_count, followers_count: followers_count } }
    end
  end

  def destroy
    user = User.find(params[:user_id])
    current_user.unfollow(user)

    # フォロー数を取得
    followings_count = current_user.followings.count
    followers_count = user.followers.count

    respond_to do |format|
      format.html { redirect_to request.referer }
      format.json { render json: { followings_count: followings_count, followers_count: followers_count } }
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