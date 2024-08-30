class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]

    if @range == "User"
      @users = User.includes(:profile_image_attachment)
                   .looks(params[:search], params[:word])
                   .order(created_at: :desc)
      render "/searches/search_result"
    elsif @range == "Post"
      @posts = Post.includes(:user, :comments)
                   .looks(params[:search], params[:word])
                   .order(created_at: :desc)
      render "/searches/search_result"
    end
  end

end
