class Api::V1::ApiController < ActionController::Base

	def auth!
		# if request.headers['Authorization']
		# 	@client = Client.find_by(token: request.headers['Authorization'])
		# 	unless @client
		# 		permission_error "User not found"
		# 	end
		# else
		# 	permission_error "User not found"
		# end
	end

	def error(message = "Internal server error")
		render_error 500, message
	end

	def param_error
		render_error 400, "Invalid Parameters"
	end

	def permission_error(message)
		render_error 401, message
	end

	def conflict(message)
		render_error 409, message
	end

	def check_validation(object)
		if !object.valid?
			render_error 400, object.errors
			return false
		end
		return true
	end

	def render_error(status, message)
		render json: {errors: message}, status: status
	end

	def render_ok(message)
		render json: {message: message}, status: 200
	end

private
    def id_param
    	params.permit(:id)[:id]
    end

end
