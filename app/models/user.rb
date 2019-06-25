class User < ApplicationRecord
	require 'digest/md5'
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
	devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
	has_secure_token :token
	has_secure_token :public_token
	attr_accessor :unread_messages

	def unique?
		return User.where('(email = ? or nickname = ?) and id <> ? ', email, nickname, (id ? id : 0)).count == 0
	end

	def avatar
		return "http://gravatar.com/avatar/#{Digest::MD5.hexdigest(email)}?size=50"
	end

	def self.find_by_public_token(user_token)
		return User.find_by(public_token: user_token)
	end

	def self.verify_login(login)
		user = User.where('email = ? or nickname = ?', login[:email], login[:email]).first
		if user
			if user.valid_password?(login[:password])
				user.regenerate_token
				user.save
				return user
			end
		end
		return nil
	end

end
