class GetMeaningsDataJob < ApplicationJob
  queue_as :default

  def self.perform(user_id)
    data = GetMeaningsData.get_words_total_data(User.find(user_id).meanings)
    Rails.logger.debug "inside GetMeaningsDataJob after getting data"
    UserMailer.meanings_data(data).deliver
    Rails.logger.debug "inside GetMeaningsDataJob after sending email"
  end
end
