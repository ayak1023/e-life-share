require 'rails_helper'

RSpec.describe Public::HomesController, type: :controller do
  describe "GET #top" do
    let!(:post1) { create(:post, created_at: 3.days.ago, favorite_count: 5, comments_count: 3) }
    let!(:post2) { create(:post, created_at: 2.days.ago, favorite_count: 10, comments_count: 5) }
    let!(:post3) { create(:post, created_at: 1.day.ago, favorite_count: 8, comments_count: 2) }

    before do
      allow(Post).to receive(:with_counts).and_return(Post.all)
    end

    context "並び替えオプションが 'created_at_desc' の場合" do
      it "投稿を作成日の降順で取得する" do
        get :top, params: { sort: 'created_at_desc' }
        expect(assigns(:posts)).to eq([post3, post2, post1])
      end
    end

    context "並び替えオプションが 'favorite_count_desc' の場合" do
      it "お気に入り数の降順で投稿を取得する" do
        get :top, params: { sort: 'favorite_count_desc' }
        expect(assigns(:posts)).to eq([post2, post3, post1])
      end
    end

    context "並び替えオプションが 'comments_count_desc_created_at_desc' の場合" do
      it "コメント数と作成日の降順で投稿を取得する" do
        get :top, params: { sort: 'comments_count_desc_created_at_desc' }
        expect(assigns(:posts)).to eq([post2, post1, post3])
      end
    end
  end
end
