class GetMeaningsDataJob < ApplicationJob
  queue_as :default

  def self.perform(user_id)
  	user = User.find(user_id)
    data = GetMeaningsData.get_words_total_data(user.meanings)
    Rails.logger.debug "inside GetMeaningsDataJob after getting data"
    UserMailer.meanings_data(data, user).deliver
    Rails.logger.debug "inside GetMeaningsDataJob after sending email"
  end
end
