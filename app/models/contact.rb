class Contact

	attr_accessor :user, :unread_messages, :last_message_at

	def self.get_by_user(user)
		messages = Message.user_messages(user)
			.distinct.pluck(:sender_id, :receiver_id)
		ids = []
		messages.each { |message| ids.push(*message) }
		users = User.where(id: ids.uniq)
		contacts = []
		users.each do |sender|
			last_message = Message.last_message(sender, user)
			next unless last_message
			contacts.push(Contact.new({
				user: sender,
				unread_messages: Message.get_unread_messages(sender, user).count,
				last_message_at: last_message.created_at
			}))
		end
		return contacts
	end

	def initialize(params = {})
		self.user = params[:user]
		self.unread_messages = params[:unread_messages]
		self.last_message_at = params[:last_message_at]
    end
end