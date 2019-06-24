class Message < ApplicationRecord
  belongs_to :sender, :class_name => "User", foreign_key: "sender_id"
  belongs_to :receiver, :class_name => "User", foreign_key: "receiver_id"

  validates_presence_of :text, :sender_id, :receiver_id

  def receiver_token=(token)
  	self.receiver = User.find_by(public_token: token)
  end
end
