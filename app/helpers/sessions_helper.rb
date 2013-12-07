module SessionsHelper

	def sign_in(user)
		cookies.permanent.signed[:remember_token] = [user.id, user.salt]
		current_user = user
		puts "@current_user : #{current_user}" 		
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user
		@current_user ||= user_from_remember_token
	end

	private

	def user_from_remember_token
		User.authenticate_with_salt(*remember_token)

	end

	def remember_token
		cookies.signed[:remember_token] || [nil, nil]
	end

	def signed_in?
		if current_user.nil?
			false
		else
			true
		end
	end

	def sign_out
		@current_user = nil
		cookies.delete(:remember_token)
	end
end
