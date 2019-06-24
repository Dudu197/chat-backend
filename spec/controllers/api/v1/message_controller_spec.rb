require 'rails_helper'
RSpec.describe Api::V1::MessageController do

  describe "POST #send_message" do
    before do
      @sender = User.new(email: "email1@mail.com", nickname: "nickname1", password: "1234567", password_confirmation: "1234567")
      @sender.save
      @receiver = User.new(email: "email2@mail.com", nickname: "nickname2", password: "1234567", password_confirmation: "1234567")
      @receiver.save
      @headers = {
        "Authorization" => @sender.token
      }
    end

    it "should return unauthorized if no token is provided in headers" do
      post :send_message, params: {message: {text: "Hi there", receiver_token: @receiver.public_token}}
      expect(response).to have_http_status(:unauthorized)
    end

    it "should return bad request if text or receiver_token is not provided" do
      request.headers.merge!(@headers)

      post :send_message, params: {message: {text: "Hi there"}}
      expect(response).to have_http_status(:bad_request)

      post :send_message, params: {message: {receiver_token: @receiver.public_token}}
      expect(response).to have_http_status(:bad_request)
    end

    it "should save message" do
      request.headers.merge!(@headers)
      post :send_message, params: {message: {text: "Hi there", receiver_token: @receiver.public_token}}
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response.keys).to match_array(["success"])
    end
  end

end