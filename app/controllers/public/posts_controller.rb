class Public::PostsController < ApplicationController
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
    @posts = Post.where(user_id: current_user.following_ids)
    sort_option = params[:sort] || 'created_at_desc'
    @sort_column, @sort_order = parse_sort_option(sort_option)

    case @sort_column
    when 'favorite_count'
      @posts = @posts
        .select('posts.*, COUNT(favorites.id) AS favorite_count')
        .left_joins(:favorites)
        .group('posts.id')
        .order("favorite_count #{@sort_order}, created_at DESC")
    when 'comments_count'
      @posts = @posts
        .select('posts.*, COUNT(comments.id) AS comments_count')
        .left_joins(:comments)
        .group('posts.id')
        .order("comments_count #{@sort_order}, created_at DESC")
    else
      @posts = @posts.order("#{@sort_column} #{@sort_order}")
    end
    @posts = @posts.page(params[:page])
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


  def create_comment
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      respond_to do |format|
        format.html { redirect_to @post }
        format.js
      end
    else
      respond_to do |format|
        format.html { render :show }
        format.js
      end
    end
  end

  def destroy_comment
    @comment = Comment.find(params[:id])
    @post = @comment.post
    if @comment.destroy
      respond_to do |format|
        format.html { redirect_to @post }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to @post, alert: 'コメントの削除に失敗しました。' }
        format.js
      end
    end
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

  def comment_params
    params.require(:comment).permit(:body)
  end

  def parse_sort_option(option)
    case option
    when 'created_at_desc'
      ['created_at', 'DESC']
    when 'created_at_asc'
      ['created_at', 'ASC']
    when 'favorite_count_desc_created_at_desc'
      ['favorite_count', 'DESC']
    when 'comments_count_desc_created_at_desc'
      ['comments_count', 'DESC']
    else
      ['created_at', 'DESC'] # デフォルトの並び順
    end
  end

end
