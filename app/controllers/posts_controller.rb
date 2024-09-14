class PostsController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update, :destroy]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to post_path(@post.id), notice: '投稿に成功しました。'
    else
      flash.now[:alert] = "投稿に失敗しました。"
      render :new
    end
  end

def index
    sort_option = params[:sort] || 'created_at_desc'
    @sort_column, @sort_order = parse_sort_option(sort_option)
    # @user.posts.with_counts スコープを使用して並び替え
    @posts = Post.with_counts.order(@sort_column).page(params[:page])
end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @comment = Comment.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])

    if params[:post][:remove_image] == '1'
      @post.image.purge
    end

    if @post.update(post_params)
      redirect_to @post, notice: '更新に成功しました。'
    else
      flash.now[:alert] = "更新に失敗しました。"
      render :edit
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to mypage_path
  end

  private

  def is_matching_login_user
    post = Post.find(params[:id])
    unless post.user_id == current_user.id
      redirect_to posts_path
    end
  end

  def post_params
    params.require(:post).permit(:title, :body, :image, category_ids: [])
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
