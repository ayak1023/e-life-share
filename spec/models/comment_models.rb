require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'バリデーションのテスト' do
    it 'bodyが存在する場合、有効である' do
      user = User.create!(email: 'test@example.com', password: 'password')
      post = Post.create!(title: 'Test Post', body: 'This is a test body', user: user)
      comment = Comment.new(body: 'This is a test comment', user: user, post: post)

      expect(comment).to be_valid
    end

    it 'bodyが空の場合、無効である' do
      user = User.create!(email: 'test@example.com', password: 'password')
      post = Post.create!(title: 'Test Post', body: 'This is a test body', user: user)
      comment = Comment.new(body: '', user: user, post: post)

      expect(comment).not_to be_valid
      expect(comment.errors[:body]).to include("can't be blank")
    end
  end

  describe 'アソシエーションのテスト' do
    it { should belong_to(:user) }
    it { should belong_to(:post) }
  end
end
