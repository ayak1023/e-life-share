require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { create(:user) }
  let(:category1) { create(:category) }
  let(:category2) { create(:category) }
  let(:category3) { create(:category) }
  let(:category4) { create(:category) }
  let(:post) { build(:post, user: user, categories: [category1, category2]) }

  describe 'バリデーション' do
    it 'タイトルが必須であること' do
      post.title = nil
      expect(post).not_to be_valid
      expect(post.errors[:title]).to include("を入力してください")
    end

    it '本文が必須であること' do
      post.body = nil
      expect(post).not_to be_valid
      expect(post.errors[:body]).to include("を入力してください")
    end

    it '最低1つのカテゴリが選択されていること' do
      post.categories = []
      expect(post).not_to be_valid
      expect(post.errors[:category_ids]).to include("少なくとも1つのカテゴリを選択してください。")
    end

    it 'カテゴリが最大3つまでであること' do
      post.categories = [category1, category2, category3, category4]
      expect(post).not_to be_valid
      expect(post.errors[:category_ids]).to include("カテゴリは最大3つまで選択できます。")
    end
  end

  describe 'メソッド#favorited_by?' do
    it 'ユーザーがその投稿をお気に入りにしているかどうかを判定できること' do
      user2 = create(:user)
      post.save!
      user2.favorites.create!(post: post)

      expect(post.favorited_by?(user2)).to be true
      expect(post.favorited_by?(user)).to be false
    end
  end

  describe 'スコープ' do
    it 'コメントとお気に入りの数が含まれていること' do
      post.save!
      post.comments.create!(user: user, content: 'テストコメント')
      user.favorites.create!(post: post)

      post_with_counts = Post.with_counts.find(post.id)
      expect(post_with_counts.comments_count).to eq 1
      expect(post_with_counts.favorite_count).to eq 1
    end
  end

  describe '検索機能' do
    it 'タイトルまたは本文に特定のキーワードが含まれる投稿を取得できること' do
      post.title = 'テストタイトル'
      post.body = 'テスト本文'
      post.save!

      search_results = Post.looks('テスト', 'タイトル')
      expect(search_results).to include(post)
    end
  end
end
