require 'rails_helper'

RSpec.describe Public::RelationshipsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before do
    sign_in user
  end

  describe "POST #create" do
    it "ユーザーをフォローする" do
      expect {
        post :create, params: { user_id: other_user.id }, format: :json
      }.to change { user.followings.count }.by(1)

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response['followings_count']).to eq(user.followings.count)
      expect(json_response['followers_count']).to eq(other_user.followers.count)
    end
  end

  describe "DELETE #destroy" do
    before { user.follow(other_user) }

    it "ユーザーのフォローを解除する" do
      expect {
        delete :destroy, params: { user_id: other_user.id }, format: :json
      }.to change { user.followings.count }.by(-1)

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response['followings_count']).to eq(user.followings.count)
      expect(json_response['followers_count']).to eq(other_user.followers.count)
    end
  end
end
