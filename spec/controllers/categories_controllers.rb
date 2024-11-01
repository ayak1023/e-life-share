require 'rails_helper'

RSpec.describe Admin::CategoriesController, type: :controller do
  let!(:category) { create(:category, name: "テストカテゴリ") }

  describe "GET #index" do
    it "全てのカテゴリを @categories に割り当て、新しいカテゴリを初期化する" do
      get :index
      expect(assigns(:categories)).to eq([category])
      expect(assigns(:new_category)).to be_a_new(Category)
      expect(response).to render_template(:index)
    end
  end

  describe "POST #create" do
    context "有効な属性の場合" do
      it "新しいカテゴリを作成し、index にリダイレクトする" do
        expect {
          post :create, params: { category: { name: "新しいカテゴリ" } }
        }.to change(Category, :count).by(1)

        expect(response).to redirect_to(admin_categories_path)
        expect(flash[:notice]).to eq('Category was successfully created.')
      end
    end

    context "無効な属性の場合" do
      it "新しいカテゴリを保存せず、index テンプレートを再レンダリングする" do
        expect {
          post :create, params: { category: { name: "" } }
        }.not_to change(Category, :count)

        expect(response).to render_template(:index)
      end
    end
  end

  describe "GET #edit" do
    it "@category に指定したカテゴリを割り当て、edit テンプレートを表示する" do
      get :edit, params: { id: category.id }
      expect(assigns(:category)).to eq(category)
      expect(response).to render_template(:edit)
    end
  end

  describe "PATCH #update" do
    context "有効な属性の場合" do
      it "カテゴリを更新し、index にリダイレクトする" do
        patch :update, params: { id: category.id, category: { name: "更新されたカテゴリ" } }
        expect(category.reload.name).to eq("更新されたカテゴリ")
        expect(response).to redirect_to(admin_categories_path)
        expect(flash[:notice]).to eq('Category was successfully updated.')
      end
    end

    context "無効な属性の場合" do
      it "カテゴリを更新せず、edit テンプレートを再レンダリングする" do
        patch :update, params: { id: category.id, category: { name: "" } }
        expect(category.reload.name).not_to eq("")
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy" do
    it "カテゴリを削除し、index にリダイレクトする" do
      expect {
        delete :destroy, params: { id: category.id }
      }.to change(Category, :count).by(-1)

      expect(response).to redirect_to(admin_categories_path)
      expect(flash[:notice]).to eq('Category was successfully deleted.')
    end
  end
end
