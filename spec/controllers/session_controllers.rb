require 'rails_helper'

RSpec.describe Public::SessionsController, type: :controller do

  before do
     @guest_user = create(:user, :guest)
     allow(User).to receive(:guest).and_return(@guest_user)
  end

  describe "POST #guest_sign_in" do
    it "ゲストユーザーでログインする" do
      post :guest_sign_in
      expect(controller.current_user).to eq(@guest_user)
    end

    it "mypage_path にリダイレクトし、通知を表示する" do
      post :guest_sign_in
      expect(response).to redirect_to(mypage_path)
      expect(flash[:notice]).to eq("guestuserでログインしました。")
    end
  end

end