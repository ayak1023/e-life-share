class Admin::DashboardsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!

  def index
    @users = User.all
  end

  def search_result
    @range = params[:range]  # @rangeをビューで使えるようにインスタンス変数にする
    keyword = params[:word]
    search_type = params[:search]

    if @range == 'User'
      @results = search_users(keyword, search_type)
    elsif @range == 'Category'
      @results = search_categories(keyword, search_type)
    end

    render 'admin/dashboards/search_result'  # search_resultビューをレンダリング
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
