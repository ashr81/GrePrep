class UserMailer < ApplicationMailer
	default from: 'web@webmanchuria.com'

	def welcome_email(user)
		@user = user
		@url = 'http://www.webmanchuria.com/'
		mail(to: @user.email, subject: 'Welcome to My Awesome Site')
	end

	def meanings_data(data, user)
		@user = user
		@data = data
		mail(to: @user.email, subject: 'Daily Dosage of Meanings')
	end
end
