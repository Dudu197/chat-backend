class Message < ApplicationRecord
  belongs_to :sender, :class_name => "User", foreign_key: "sender_id"
  belongs_to :receiver, :class_name => "User", foreign_key: "receiver_id"

  self.per_page = 10

  validates_presence_of :text, :sender_id, :receiver_id

  def sender_token
  	return sender.public_token
  end

  def receiver_token
  	return receiver.public_token
  end

  def receiver_token=(token)
  	self.receiver = User.find_by_public_token(token)
  end

  def self.find_sended_messages(sender, receiver)
    return Message.where(sender_id: sender.id, receiver_id: receiver.id)
       .or(Message.where(sender_id: receiver.id, receiver_id: sender.id))
  end

  def self.get_unread_messages(sender, receiver)
    return Message.where(sender_id: sender.id, receiver_id: receiver.id, read_at: nil)
  end

  def self.user_messages(user)
    return Message.where(sender_id: user.id)
            .or(Message.where(receiver_id: user.id))
  end

  def self.last_message(sender, receiver)
    return Message.find_sended_messages(sender, receiver).order(created_at: :desc).first
  end

end
