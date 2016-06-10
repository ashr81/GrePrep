class UserMailer < ApplicationMailer
	default from: 'notifications@example.com'

	def welcome_email(user)
		@user = user
		@url = 'http://www.webmanchuria.com/'
		mail(to: @user.email, subject: 'Welcome to My Awesome Site')
	end
end
