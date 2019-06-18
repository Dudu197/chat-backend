class User < ApplicationRecord
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
	devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
	has_secure_token :token

	def unique?
		return User.where('(email = ? or nickname = ?) and id <> ? ', email, nickname, (id ? id : 0)).count == 0
	end

end
