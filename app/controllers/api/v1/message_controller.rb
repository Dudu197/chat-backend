class Api::V1::MessageController < Api::V1::ApiController
	before_action :auth!

	def send_message
		message = Message.new(message_params)
		message.sender = @user
	    if message.save
	      render json: {success: true}
	    elsif check_validation message
	      error
	    end
	end

private
    def message_params
      params.require(:message).permit(:text, :receiver_token)
    end
end