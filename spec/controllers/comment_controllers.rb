require 'rails_helper'

RSpec.describe Public::CommentsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:post) { create(:post) }
  let!(:comment) { create(:comment, user: user, post: post) }

  before do
    sign_in user
  end

  describe 'POST #create' do
    context '正常なコメント作成' do
      it 'コメントを保存し、投稿ページにリダイレクトすること' do
        expect {
          post :create, params: { post_id: post.id, comment: { body: '参考になります！' } }
        }.to change(Comment, :count).by(1)
        expect(response).to redirect_to(post_path(post))
      end
    end

    context '無効なコメント作成' do
      it 'コメント作成に失敗し、エラーメッセージを表示して投稿ページにリダイレクトすること' do
        expect {
          post :create, params: { post_id: post.id, comment: { body: '' } }
        }.not_to change(Comment, :count)
        expect(response).to redirect_to(post_path(post))
        expect(flash[:alert]).to eq("コメント送信に失敗しました。")
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'コメントを削除し、投稿ページにリダイレクトすること' do
      expect {
        delete :destroy, params: { post_id: post.id, id: comment.id }
      }.to change(Comment, :count).by(-1)
      expect(response).to redirect_to(post_path(post))
    end
  end
end
