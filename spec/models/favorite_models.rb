require 'rails_helper'

RSpec.describe Favorite, type: :model do
  let(:user) { create(:user) }
  let(:post) { create(:post) }

  describe 'バリデーションのテスト' do
    context 'user_idとpost_idの組み合わせがユニークな場合' do
      it 'バリデーションが通ること' do
        favorite = Favorite.new(user: user, post: post)
        expect(favorite).to be_valid
      end
    end

    context 'user_idとpost_idの組み合わせが重複している場合' do
      before do
        Favorite.create!(user: user, post: post)
      end

      it 'バリデーションエラーになること' do
        duplicate_favorite = Favorite.new(user: user, post: post)
        expect(duplicate_favorite).not_to be_valid
        expect(duplicate_favorite.errors[:user_id]).to include('はすでに存在します')
      end
    end
  end

  describe 'アソシエーションのテスト' do
    it 'Userモデルに属していること' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end

    it 'Postモデルに属していること' do
      association = described_class.reflect_on_association(:post)
      expect(association.macro).to eq :belongs_to
    end
  end
end
