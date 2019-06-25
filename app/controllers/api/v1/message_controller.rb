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

	def get_messages
		if receiver_token_param
			receiver = User.find_by_public_token(receiver_token_param[:receiver_token])
			messages = Message.find_sended_messages(@user. receiver)
			messages.order(created_at: :desc).paginate(page: receiver_token_param[:page])
			render json: messages, methods: [:sender_token, :receiver_token], except: [:id, :sender_id, :receiver_id]
		else	
			param_error
		end
	end

private
    def message_params
      params.require(:message).permit(:text, :receiver_token)
    end

    def receiver_token_param
      params.permit(:receiver_token, :page)
    end
end