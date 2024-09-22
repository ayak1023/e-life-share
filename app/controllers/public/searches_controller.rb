class Public::SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]
    keyword = params[:word]
    sort_option = params[:sort] || 'created_at_desc' # デフォルトのソート順を設定

    if keyword.blank?
      flash.now[:alert] = "検索キーワードを入力してください。"
      @users = [] if @range == "User"
      @posts = [] if @range == "Post" || @range == "Category"
      render "public/search_result" and return
    end

    if @range == "User"
      @users = User.includes(:profile_image_attachment)
                   .looks(params[:search], keyword)
                   .order(created_at: :desc)
                   .page(params[:page])
      render "public/searches/search_result"
    elsif @range == "Post"
      @posts = Post.includes(:user, :comments)
                   .looks(params[:search], keyword)
                   .with_favorite_count
                   .with_comments_count
                   .order(parse_sort_option(sort_option))
                   .page(params[:page])
      render "public/searches/search_result"
    elsif @range == "Category"
      category = Category.find_by('LOWER(name) = ?', keyword.downcase)
      if category
        @posts = category.posts
                         .with_favorite_count
                         .with_comments_count
                         .order(parse_sort_option(sort_option))
                         .page(params[:page])
      else
        @posts = []
      end
      render "public/searches/search_result"
    end
  end

  private

  def parse_sort_option(option)
    case option
    when 'created_at_desc'
      'created_at DESC'
    when 'created_at_asc'
      'created_at ASC'
    when 'favorite_count_desc_created_at_desc'
      'favorite_count DESC, created_at DESC'
    when 'comments_count_desc_created_at_desc'
      'comments_count DESC, created_at DESC'
    else
      'created_at DESC' # デフォルトの並び順
    end
  end

end
