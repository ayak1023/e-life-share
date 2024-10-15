require 'rails_helper'

RSpec.describe Public::UsersController, type: :controller do
  let!(:user) { create(:user) }  # 通常のユーザー
  let!(:guest_user) { create(:user, :guest) }  # ゲストユーザー
  let!(:other_user) { create(:user) }  # 他のユーザー
  let!(:post) { create(:post, user: user) }

  before do
    sign_in user  # ユーザーでログイン
  end

  describe 'GET #index' do
    it '正常に応答すること' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'ユーザー一覧を取得すること' do
      get :index
      expect(assigns(:users)).to include(user, guest_user, other_user)
    end
  end

  describe 'GET #mypage' do
    it 'マイページを表示できること' do
      get :mypage
      expect(response).to have_http_status(:success)
      expect(assigns(:posts)).to eq(user.posts.order(created_at: :desc))
    end
  end

  describe 'GET #show' do
    it 'ユーザーのプロフィールページを表示できること' do
      get :show, params: { id: user.id }
      expect(response).to have_http_status(:success)
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'GET #edit' do
    it '自身の編集ページを表示できること' do
      get :edit, params: { id: user.id }
      expect(response).to have_http_status(:success)
    end

    it '他のユーザーの編集ページにはアクセスできないこと' do
      get :edit, params: { id: other_user.id }
      expect(response).to redirect_to(mypage_path)
    end

    it 'ゲストユーザーは編集ページに遷移できないこと' do
      sign_in guest_user
      get :edit, params: { id: guest_user.id }
      expect(response).to redirect_to(user_path(user))
      expect(flash[:alert]).to eq("ゲストユーザーはプロフィール編集画面へ遷移できません。")
    end
  end

  describe 'PATCH #update' do
    it 'プロフィールを更新できること' do
      patch :update, params: { id: user.id, user: { name: 'Updated Name' } }
      user.reload
      expect(user.name).to eq('Updated Name')
      expect(response).to redirect_to(user_path(user))
    end

    it '更新に失敗した場合、editを再レンダリングすること' do
      patch :update, params: { id: user.id, user: { name: '' } }
      expect(response).to render_template(:edit)
      expect(flash[:alert]).to eq("更新に失敗しました。")
    end
  end

  describe 'DELETE #destroy' do
    it 'ユーザーを削除できること' do
      expect {
        delete :destroy, params: { id: user.id }
      }.to change(User, :count).by(-1)
      expect(response).to redirect_to(new_user_registration_path)
    end
  end

  describe 'GET #favorites' do
    it 'お気に入りの投稿を表示できること' do
      favorite = create(:favorite, user: user, post: post)
      get :favorites, params: { id: user.id }
      expect(response).to have_http_status(:success)
      expect(assigns(:favorite_posts)).to include(post)
    end
  end

  describe 'before_action filters' do
    describe '#is_matching_login_user' do
      it '自身のページにはアクセスできること' do
        get :edit, params: { id: user.id }
        expect(response).to have_http_status(:success)
      end

      it '他のユーザーのページにはアクセスできないこと' do
        get :edit, params: { id: other_user.id }
        expect(response).to redirect_to(mypage_path)
      end
    end

    describe '#ensure_guest_user' do
      it 'ゲストユーザーはプロフィール編集画面に遷移できないこと' do
        sign_in guest_user
        get :edit, params: { id: guest_user.id }
        expect(response).to redirect_to(user_path(user))
        expect(flash[:alert]).to eq("ゲストユーザーはプロフィール編集画面へ遷移できません。")
      end
    end
  end
end
