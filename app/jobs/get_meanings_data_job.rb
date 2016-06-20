class GetMeaningsDataJob < ApplicationJob
  queue_as :default

  def self.perform(user_id)
  	user = User.find(user_id)
	array_index_start = (Date.today.yday - 172)*20          #172 as Start date is on 20-June-2016
	array_index_end =  (Date.today.yday - 171)*20
    data = GetMeaningsData.get_words_total_data(user.words[array_index_start...array_index_end])
    Rails.logger.debug "inside GetMeaningsDataJob after before give gre_names getting data #{data}"
    user_meanings = user.meanings[array_index_start...array_index_end]
    data.each_with_index{|(key,value), index| value["original_gre_meaning"] = user_meanings[index]}
    Rails.logger.debug "inside GetMeaningsDataJob after getting data #{data}"
    UserMailer.meanings_data(data, user).deliver
    Rails.logger.debug "inside GetMeaningsDataJob after sending email to #{user_id}"
  end
end
