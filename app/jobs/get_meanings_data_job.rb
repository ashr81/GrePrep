class GetMeaningsDataJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    data = GetMeaningsData.get_words_total_data(User.find(user_id).meanings)
    UserMailer.meanings_data(data)
  end
end
