class Public::CategoriesController < ApplicationController
  def posts
    @category = Category.find(params[:id])
    sort_option = params[:sort] || 'created_at_desc' # デフォルトのソート順を設定

    @posts = @category.posts
                      .with_favorite_count
                      .with_comments_count
                      .order(parse_sort_option(sort_option))
                      .page(params[:page])
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
