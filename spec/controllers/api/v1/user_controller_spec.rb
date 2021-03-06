require 'rails_helper'
RSpec.describe Api::V1::UserController do

  describe "POST #create" do
    before do
      post :create, params: {user: {email: "email1@mail.com", nickname: "nickname1", password: "1234567", password_confirmation: "1234567"}}
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "JSON body response contains expected pratice attributes" do
      json_response = JSON.parse(response.body)
      expect(json_response.keys).to match_array(["id", "email", "nickname", "token", "public_token", "created_at", "updated_at"])
    end

    it "cannot have two users with same email" do
      post :create, params: {user: {email: "email1@mail.com", nickname: "nickname2", password: "1234567", password_confirmation: "1234567"}}
      expect(response).to have_http_status(:conflict)
      json_response = JSON.parse(response.body)
      expect(json_response.keys).to match_array(["errors"])
    end

    it "cannot have two users with same nickname" do
      post :create, params: {user: {email: "email2@mail.com", nickname: "nickname1", password: "1234567", password_confirmation: "1234567"}}
      expect(response).to have_http_status(:conflict)
      json_response = JSON.parse(response.body)
      expect(json_response.keys).to match_array(["errors"])
    end

    it "create another user with different email and nickname" do
      post :create, params: {user: {email: "email2@mail.com", nickname: "nickname2", password: "1234567", password_confirmation: "1234567"}}
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response.keys).to match_array(["id", "email", "nickname", "token", "public_token", "created_at", "updated_at"])
    end
  end

  describe "POST #login" do
    before do
      post :create, params: {user: {email: "email1@mail.com", nickname: "nickname1", password: "1234567", password_confirmation: "1234567"}}
    end

    it "successfully login with correct email" do
      post :login, params: {user: {email: "email1@mail.com", password: "1234567"}}
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response.keys).to match_array(["id", "email", "nickname", "token", "public_token", "created_at", "updated_at"])
    end

    it "successfully login with correct nickname" do
      post :login, params: {user: {email: "nickname1", password: "1234567"}}
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response.keys).to match_array(["id", "email", "nickname", "token", "public_token", "created_at", "updated_at"])
    end

    it "unsuccessfully login with incorrect password" do
      post :login, params: {user: {email: "email1@mail.com", password: "1234569"}}
      expect(response).to have_http_status(:unauthorized)
      json_response = JSON.parse(response.body)
      expect(json_response.keys).to match_array(["errors"])
    end

    it "token should change after login" do
      user = User.find_by(email: "email1@mail.com")
      post :login, params: {user: {email: "email1@mail.com", password: "1234567"}}
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response["token"]).not_to be user.token
    end
  end

end