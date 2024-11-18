require 'rails_helper'

RSpec.describe category, type: :model do
  describe 'Validations' do
    describe 'バリデーション' do
    it 'ユニークなnameであれば有効であること' do
      category = Category.new(name: 'テストカテゴリ')
      expect(category).to be_valid
    end

    it 'nameがない場合は無効であること' do
      category = Category.new(name: nil)
      expect(category).not_to be_valid
      expect(category.errors[:name]).to include("can't be blank")
    end

    it 'nameが重複している場合は無効であること' do
      Category.create!(name: 'テストカテゴリ')
      category = Category.new(name: 'テストカテゴリ')
      expect(category).not_to be_valid
      expect(category.errors[:name]).to include("has already been taken")
    end
  end

  describe '.looksメソッド' do
    before do
      @category1 = Category.create!(name: 'Rails')
      @category2 = Category.create!(name: 'Ruby')
      @category3 = Category.create!(name: 'JavaScript')
    end

    context '検索方法がperfect_matchの場合' do
      it '完全一致するカテゴリを返すこと' do
        result = Category.looks('perfect_match', 'Ruby')
        expect(result).to contain_exactly(@category2)
      end
    end

    context '検索方法がforward_matchの場合' do
      it '指定した単語で始まるカテゴリを返すこと' do
        result = Category.looks('forward_match', 'Ra')
        expect(result).to contain_exactly(@category1)
      end
    end

    context '検索方法がbackward_matchの場合' do
      it '指定した単語で終わるカテゴリを返すこと' do
        result = Category.looks('backward_match', 'Script')
        expect(result).to contain_exactly(@category3)
      end
    end

    context '検索方法がpartial_matchの場合' do
      it '指定した単語を含むカテゴリを返すこと' do
        result = Category.looks('partial_match', 'Ruby')
        expect(result).to contain_exactly(@category2)
      end
    end

    context '検索方法が不正またはnilの場合' do
      it 'すべてのカテゴリを返すこと' do
        result = Category.looks('invalid_match', 'Ruby')
        expect(result).to contain_exactly(@category1, @category2, @category3)
      end
    end
  end
  end
end