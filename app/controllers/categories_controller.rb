class CategoriesController < ApplicationController
  def posts
    @category = Category.find(params[:id])
    @posts = @category.posts.order(created_at: :desc)
  end
end
