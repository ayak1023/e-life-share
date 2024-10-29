require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  describe 'DELETE #destroy' do
    let!(:admin) { create(:user, :admin) }
    let!(:user) { create(:user) }

    before do
      sign_in admin
    end

    it 'ユーザーを削除し、管理者ダッシュボードにリダイレクトする' do
      expect {
        delete :destroy, params: { id: user.id }
      }.to change(User, :count).by(-1)

      expect(response).to redirect_to(admin_dashboards_path)
      expect(flash[:notice]).to eq 'ユーザーを削除しました。'
    end
  end
end
