class PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to post_path(@post.id), notice: '投稿に成功しました。'
    else
      flash.now[:alert] = "投稿に失敗しました。"
      render :new
    end
  end

  #ログイン前のTopページ
  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
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
      render :edit, notice: '更新に失敗しました。'
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to '/posts'
  end

  private
  def post_params
    params.require(:post).permit(:title, :body, :image)
  end
end
