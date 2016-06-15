require 'rest_client'
class GetMeaningsData
	def self.get_api_key
		return "a2a73e7b926c924fad7001ca3111acd55af2ffabf50eb4ae5"
	end
	def self.get_words_total_data(words_array)
		words_data = []
		words_array.each do |word|
			words_data.push(get_word_data(word)) 
		end
		Rails.logger.debug "Seperating API Data<=========================================================>"
		return words_data
	end
	def self.get_word_data(word)
		word_data = {}
		word_data["meaning"] = get_word_meaning(word)
		word_data["examples"] = get_word_examples(word)
		word_data["definition"] = get_word_definition(word)
		return word_data
	end
	def self.get_word_meaning(word)
		response = RestClient.get "http://api.wordnik.com:80/v4/words.json/search/#{word}?caseSensitive=true&minCorpusCount=5&maxCorpusCount=-1&minDictionaryCount=1&maxDictionaryCount=-1&minLength=1&maxLength=-1&skip=0&limit=10&api_key=#{get_api_key}"
		Rails.logger.debug "Response for wordnik #{response}"
		response = JSON.parse(response)
		return response
	end
	def self.get_word_examples(word)
		response = RestClient.get "http://api.wordnik.com:80/v4/word.json/#{word}/examples?limit=200&includeRelated=true&useCanonical=false&includeTags=false&api_key=#{get_api_key}"
		Rails.logger.debug "Response for wordnik #{response}"
		response = JSON.parse(response)
		return response
	end
	def self.get_word_definition(word)
		response = RestClient.get "http://api.wordnik.com:80/v4/word.json/#{word}/definitions?limit=200&includeRelated=true&useCanonical=false&includeTags=false&api_key=#{get_api_key}"
		Rails.logger.debug "Response for wordnik #{response}"
		response = JSON.parse(response)
		return response
	end
end