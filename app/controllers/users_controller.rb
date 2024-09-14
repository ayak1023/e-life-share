class UsersController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update, :destroy]
  before_action :ensure_guest_user, only: [:edit]

  def mypage
    sort_option = params[:sort] || 'created_at_desc'
    @sort_column, @sort_order = parse_sort_option(sort_option)
    @posts = current_user.posts.with_counts.order(@sort_column)
  end

  def show
    @user = User.find(params[:id])

    # フォームから送信された並び替えオプションを取得
    sort_option = params[:sort] || 'created_at_desc'
    @sort_column, @sort_order = parse_sort_option(sort_option)
    # @user.posts.with_counts スコープを使用して並び替え
    @posts = @user.posts.with_counts.order(@sort_column)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "更新に成功しました。"
      redirect_to user_path(current_user.id)
    else
      flash.now[:alert] = "更新に失敗しました。"
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = 'ユーザーを削除しました。'
    redirect_to new_user_registration_path
  end

  def favorites
    @user = User.find(params[:id])
    favorites = Favorite.where(user_id: @user.id).order(created_at: :desc)
    post_ids = favorites.pluck(:post_id)
    @favorite_posts = Post.find(post_ids)
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def is_matching_login_user
    user = User.find(params[:id])
    unless user.id == current_user.id
      redirect_to mypage_path
    end
  end

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.guest_user?
      redirect_to user_path(current_user), alert: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
    end
  end

  def parse_sort_option(option)
    case option
    when 'created_at_desc'
      ['created_at DESC']
    when 'created_at_asc'
      ['created_at ASC']
    when 'favorite_count_desc_created_at_desc'
      ['favorite_count DESC, created_at DESC']
    when 'comments_count_desc_created_at_desc'
      ['comments_count DESC, created_at DESC']
    else
      ['created_at DESC'] # デフォルトの並び順
    end
  end

end
