require 'rails_helper'

RSpec.describe Public::CategoriesController, type: :controller do
  describe 'GET #posts' do
    let(:category) { create(:category) }
    let!(:post1) { create(:post, category: category, created_at: 2.days.ago, favorite_count: 5, comments_count: 3) }
    let!(:post2) { create(:post, category: category, created_at: 1.day.ago, favorite_count: 2, comments_count: 5) }

    context 'デフォルトのソート順（作成日の降順）で取得' do
      it '作成日の降順で投稿を取得する' do
        get :posts, params: { id: category.id }
        expect(assigns(:posts)).to eq([post2, post1])
      end
    end

    context '作成日の昇順で取得' do
      it '作成日の昇順で投稿を取得する' do
        get :posts, params: { id: category.id, sort: 'created_at_asc' }
        expect(assigns(:posts)).to eq([post1, post2])
      end
    end

    context 'いいね数の降順×作成日の降順で取得' do
      it 'いいね数と作成日の降順で投稿を取得する' do
        get :posts, params: { id: category.id, sort: 'favorite_count_desc_created_at_desc' }
        expect(assigns(:posts)).to eq([post1, post2])
      end
    end

    context 'コメント数の降順×作成日の降順で取得' do
      it 'コメント数と作成日の降順で投稿を取得する' do
        get :posts, params: { id: category.id, sort: 'comments_count_desc_created_at_desc' }
        expect(assigns(:posts)).to eq([post2, post1])
      end
    end
  end
end