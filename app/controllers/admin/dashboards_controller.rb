class Admin::DashboardsController < ApplicationController
    layout 'admin'
    before_action :authenticate_admin!
    def index
        @users = User.all
    end

def search_result
    # 検索条件を取得
    range = params[:range] # ユーザー, 投稿, カテゴリから選択
    keyword = params[:word]
    search_type = params[:search] # 部分一致、完全一致など

    # 検索ロジックの実装
    if range == 'User'
      @results = search_users(keyword, search_type)
    elsif range == 'Post'
      @results = search_posts(keyword, search_type)
    elsif range == 'Category'
      @results = search_categories(keyword, search_type)
    end

    # 検索結果をビューで表示
    render 'admin/dashboards/search_result'
end

  private

  # ユーザー検索
  def search_users(keyword, search_type)
    case search_type
    when 'partial_match'
      User.where('name LIKE ?', "%#{keyword}%")
    when 'perfect_match'
      User.where(name: keyword)
    when 'forward_match'
      User.where('name LIKE ?', "#{keyword}%")
    when 'backward_match'
      User.where('name LIKE ?', "%#{keyword}")
    end
  end

  # カテゴリ検索
  def search_categories(keyword, search_type)
    case search_type
    when 'partial_match'
      Category.where('name LIKE ?', "%#{keyword}%")
    when 'perfect_match'
      Category.where(name: keyword)
    when 'forward_match'
      Category.where('name LIKE ?', "#{keyword}%")
    when 'backward_match'
      Category.where('name LIKE ?', "%#{keyword}")
    end
  end
end
