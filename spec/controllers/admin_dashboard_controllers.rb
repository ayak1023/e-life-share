require 'rails_helper'

RSpec.describe Admin::DashboardsController, type: :controller do
  let!(:admin) { create(:user, :admin) }
  let!(:user) { create(:user, name: "テストユーザー") }
  let!(:category) { create(:category, name: "テストカテゴリ") }

  before do
    sign_in admin
  end

  describe "GET #index" do
    it "全てのユーザーを @users に割り当てる" do
      get :index
      expect(assigns(:users)).to eq([user])
      expect(response).to render_template(:index)
    end
  end

  describe "GET #search_result" do
    context "検索範囲がユーザーの場合" do
      it "部分一致検索でユーザーを検索し、search_result ビューをレンダリングする" do
        get :search_result, params: { range: 'User', word: 'テスト', search: 'partial_match' }
        expect(assigns(:results)).to include(user)
        expect(response).to render_template('admin/dashboards/search_result')
      end

      it "完全一致検索でユーザーを検索し、search_result ビューをレンダリングする" do
        get :search_result, params: { range: 'User', word: 'テストユーザー', search: 'perfect_match' }
        expect(assigns(:results)).to include(user)
        expect(response).to render_template('admin/dashboards/search_result')
      end

      it "前方一致検索でユーザーを検索し、search_result ビューをレンダリングする" do
        get :search_result, params: { range: 'User', word: 'テスト', search: 'forward_match' }
        expect(assigns(:results)).to include(user)
        expect(response).to render_template('admin/dashboards/search_result')
      end

      it "後方一致検索でユーザーを検索し、search_result ビューをレンダリングする" do
        get :search_result, params: { range: 'User', word: 'ユーザー', search: 'backward_match' }
        expect(assigns(:results)).to include(user)
        expect(response).to render_template('admin/dashboards/search_result')
      end
    end

  end
end
