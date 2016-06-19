require 'csv'
desc "This task to save words and meanings from csv to database"
task :save_words_and_meanings_from_csv_to_database, [:file] => :environment do |t, args|
	import_file_url = args[:file]
	puts "file url: https://docs.google.com/spreadsheets/d/1NuyzWBwJ6HGYWvNImNqh93B7cExC7UFuyV56zDd-yro/export?format=csv"
  	puts import_file_url

  	upload_file_path = Rails.root.join("tmp", (0...10).map { ('a'..'z').to_a[rand(26)] }.join + "_", 'sch_reports_#{Process.pid}.csv')

  	agent = Mechanize.new
  	agent.get(import_file_url).save(upload_file_path)

  	csv = CSV.read(upload_file_path)
  	words = []
  	meanings = []
  	csv.each_with_index do |row,index|
  		begin
  			words.push(row[0])
  			word_meaning = row[1]
  			row[2..-1].each{|word| word_meaning+=",#{word}"}
  			meanings.push(word_meaning)
  		rescue Exception => e
      		puts e.message
      		Rails.logger.error e.message
      		Rails.logger.error e.backtrace.join("\n")
    	end
  	end
  	user = User.first
  	user.words = words
  	user.save!
  	user.meanings = meanings
  	user.save!
  	Rails.logger.debug "Script Executed and saved!"
end