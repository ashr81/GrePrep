desc "Gets meanings data at scheduled time"
task :get_meanings_to_email,[:user_ids] => [:environment] do |t,args|
  args[:user_ids].split(",").each do |user_id|
  	GetMeaningsDataJob.perform(user_id.to_i)
  end
end
