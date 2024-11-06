require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do


  describe '認証の設定' do
    before do
      allow(controller).to receive(:admin_controller?).and_return(false)
    end

    context '公開アクション (top)' do
      it 'ユーザー認証を要求しない' do
        get :top
        expect(response).to have_http_status(:success)
      end
    end

    context '非公開アクション (index)' do
      it 'ユーザー認証を要求する' do
        allow(controller).to receive(:authenticate_user!).and_return(false)
        expect(controller).to receive(:authenticate_user!)
        get :index
      end
    end
  end

  describe '管理者コントローラの認証設定' do
    before do
      allow(controller).to receive(:admin_controller?).and_return(true)
    end

    it '管理者認証を要求する' do
      expect(controller).to receive(:authenticate_admin!)
      get :index
    end
  end

  describe '許可パラメータの設定' do
    before do
      allow(controller).to receive(:devise_controller?).and_return(true)
    end

    it 'サインアップ時にnameを許可する' do
      params = ActionController::Parameters.new(user: { name: 'テストユーザー' })
      controller.send(:configure_permitted_parameters)
      expect(controller.devise_parameter_sanitizer.for(:sign_up)).to include(:name)
    end

    it 'アカウント更新時にnameを許可する' do
      params = ActionController::Parameters.new(user: { name: 'テストユーザー' })
      controller.send(:configure_permitted_parameters)
      expect(controller.devise_parameter_sanitizer.for(:account_update)).to include(:name)
    end
  end
end
