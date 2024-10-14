require 'rails_helper'

RSpec.describe Public::PostsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let!(:comment) { create(:comment, post: post, user: user) }

  before do
    sign_in user
  end

  describe "GET #new" do
    it "新規作成ページを表示する" do
      get :new
      expect(response).to render_template(:new)
      expect(assigns(:post)).to be_a_new(Post)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "新しい投稿を作成し、投稿ページにリダイレクトする" do
        post_params = { title: "New Post", body: "Post body", user_id: user.id }
        expect {
          post :create, params: { post: post_params }
        }.to change(Post, :count).by(1)
        expect(response).to redirect_to(post_path(assigns(:post)))
        expect(flash[:notice]).to eq('投稿に成功しました。')
      end
    end

    context "with invalid attributes" do
      it "投稿を作成せず、新規作成ページを表示する" do
        post_params = { title: "", body: "", user_id: user.id }
        expect {
          post :create, params: { post: post_params }
        }.not_to change(Post, :count)
        expect(response).to render_template(:new)
        expect(flash.now[:alert]).to eq("投稿に失敗しました。")
      end
    end
  end

  describe "GET #index" do
    it "投稿一覧を @posts に割り当て、一覧ページを表示する" do
      get :index
      expect(assigns(:posts)).to eq([post])
      expect(response).to render_template(:index)
    end
  end

  describe "GET #show" do
    it "投稿を @post に割り当て、詳細ページを表示する" do
      get :show, params: { id: post.id }
      expect(assigns(:post)).to eq(post)
      expect(response).to render_template(:show)
    end
  end

  describe "GET #edit" do
    context "when user is the owner of the post" do
      it "編集ページを表示する" do
        get :edit, params: { id: post.id }
        expect(assigns(:post)).to eq(post)
        expect(response).to render_template(:edit)
      end
    end

    context "when user is not the owner" do
      it "投稿一覧ページにリダイレクトする" do
        sign_in other_user
        get :edit, params: { id: post.id }
        expect(response).to redirect_to(posts_path)
      end
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      it "投稿を更新し、投稿ページにリダイレクトする" do
        patch :update, params: { id: post.id, post: { title: "Updated" } }
        post.reload
        expect(post.title).to eq("Updated")
        expect(response).to redirect_to(post_path(post))
        expect(flash[:notice]).to eq('更新に成功しました。')
      end
    end

    context "with invalid attributes" do
      it "投稿を更新せず、編集ページを表示する" do
        patch :update, params: { id: post.id, post: { title: "" } }
        expect(response).to render_template(:edit)
        expect(flash.now[:alert]).to eq("更新に失敗しました。")
      end
    end
  end

  describe "DELETE #destroy" do
    it "投稿を削除し、マイページにリダイレクトする" do
      expect {
        delete :destroy, params: { id: post.id }
      }.to change(Post, :count).by(-1)
      expect(response).to redirect_to(mypage_path)
    end
  end

  describe "POST #create_comment" do
    it "新しいコメントを作成し、JS形式で表示する" do
      comment_params = { body: "New Comment", post_id: post.id }
      expect {
        post :create_comment, params: { post_id: post.id, comment: comment_params }, format: :js
      }.to change(Comment, :count).by(1)
      expect(response).to render_template(:create_comment)
    end
  end

  describe "DELETE #destroy_comment" do
    it "コメントを削除し、JS形式で表示する" do
      expect {
        delete :destroy_comment, params: { id: comment.id }, format: :js
      }.to change(Comment, :count).by(-1)
      expect(response).to render_template(:destroy_comment)
    end
  end

end
