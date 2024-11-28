require 'rails_helper'

RSpec.describe CategoryPost, type: :model do
  describe '関連付けのテスト' do
    it 'Postに属していること' do
      should belong_to(:post)
    end

    it 'Categoryに属していること' do
      should belong_to(:category)
    end
  end

  describe 'バリデーションのテスト' do
    it '有効な属性の場合は有効' do
      post = Post.create(title: 'テスト投稿', content: 'テスト内容')
      category = Category.create(name: 'テストカテゴリー')
      category_post = CategoryPost.new(post: post, category: category)
      expect(category_post).to be_valid
    end

    it 'Postが無い場合は無効' do
      category
    end
  end
end