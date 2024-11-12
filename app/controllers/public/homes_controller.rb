class Public::HomesController < ApplicationController
  def top
    sort_option = params[:sort] || 'created_at_desc'
    @sort_columns = parse_sort_option(sort_option)
    @posts = Post.with_counts.order(@sort_columns).page(params[:page])
  end

  def about
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
