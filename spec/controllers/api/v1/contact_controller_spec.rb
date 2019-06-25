require 'rails_helper'
RSpec.describe Api::V1::ContactController do

  describe "POST #get_contacts" do
    before do
      @sender = User.new(email: "email1@mail.com", nickname: "nickname1", password: "1234567", password_confirmation: "1234567")
      @sender.save
      @receiver = User.new(email: "email2@mail.com", nickname: "nickname2", password: "1234567", password_confirmation: "1234567")
      @receiver.save

      messages = ["Hello", "Hi there", "Hows going"]
      senders = [@sender, @receiver, @sender]
      receivers = [@receiver, @sender, @receiver]
      read_at = [DateTime.now, DateTime.now, nil]

      messages.each_with_index do |message, i|
        Message.new({
          text: messages[i],
          sender: senders[i],
          receiver: receivers[i],
          read_at: read_at[i]
        }).save
      end

      @headers = {
        "Authorization" => @sender.token
      }
    end

    it "should return unauthorized if no token is provided in headers" do
      get :get_contacts
      expect(response).to have_http_status(:unauthorized)
    end

    it "should save message" do
      request.headers.merge!(@headers)
      get :get_contacts
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      json_response.each do |contact|
        expect(contact.keys).to match_array(["user", "unread_messages", "last_message_at"])
        expect(contact["user"].keys).to match_array(["email", "nickname", "public_token", "created_at", "updated_at"])
      end
    end
  end

end