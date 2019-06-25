class Api::V1::ContactController < Api::V1::ApiController
	before_action :auth!

	def get_contacts
		contacts = Contact.get_by_user(@user).sort_by{ |c| c.last_message_at}.reverse
		render json: contacts, except: [:id, :token]
	end

end