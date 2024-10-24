require 'rails_helper'

RSpec.describe Public::FavoritesController, type: :controller do
  let(:user) { create(:user) }
  let(:post) { create(:post) }

  before do
    sign_in user
  end

  describe 'POST #create' do
    it 'お気に入りを作成できること' do
      expect {
        post :create, params: { post_id: post.id }, xhr: true
      }.to change(Favorite, :count).by(1)
    end

    it 'HTMLリクエスト時に元のページにリダイレクトすること' do
      post :create, params: { post_id: post.id }
      expect(response).to redirect_to(post_path(post))
    end

    it 'JSリクエスト時に成功すること' do
      post :create, params: { post_id: post.id }, xhr: true
      expect(response).to have_http_status(:success)
    end
  end

  describe 'DELETE #destroy' do
    let!(:favorite) { create(:favorite, user: user, post: post) }

    it 'お気に入りを削除できること' do
      expect {
        delete :destroy, params: { post_id: post.id }, xhr: true
      }.to change(Favorite, :count).by(-1)
    end

    it 'HTMLリクエスト時に元のページにリダイレクトすること' do
      delete :destroy, params: { post_id: post.id }
      expect(response).to redirect_to(post_path(post))
    end

    it 'JSリクエスト時に成功すること' do
      delete :destroy, params: { post_id: post.id }, xhr: true
      expect(response).to have_http_status(:success)
    end
  end
end
