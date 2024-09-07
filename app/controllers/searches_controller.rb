class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]
    keyword = params[:word]

    if keyword.blank?
      flash.now[:alert] = "検索キーワードを入力してください。"
      @users = [] if @range == "User"
      @posts = [] if @range == "Post" || @range == "Category"
      render "/searches/search_result" and return
    end

    if @range == "User"
      @users = User.includes(:profile_image_attachment)
                   .looks(params[:search], keyword)
                   .order(created_at: :desc)
      render "/searches/search_result"
    elsif @range == "Post"
      @posts = Post.includes(:user, :comments)
                   .looks(params[:search], keyword)
                   .order(created_at: :desc)
      render "/searches/search_result"
    elsif @range == "Category"
      category = Category.find_by('LOWER(name) = ?', keyword.downcase)
      if category
        @posts = category.posts.order(created_at: :desc)
      else
        @posts = []
      end
      render "/searches/search_result"
    end
  end
end
