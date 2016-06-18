require 'rest_client'
class GetMeaningsData
	def self.get_api_key
		return "a2a73e7b926c924fad7001ca3111acd55af2ffabf50eb4ae5"
	end

	def self.get_dictionary_api_key
		return "a5e2a9d9-7a19-4248-95ef-92a0dc21ff46"
	end

	def self.get_words_total_data(words_array)
		begin
			words_data = {}
			words_array.each do |word|
				words_data[word] = get_word_data(word)
			end
			Rails.logger.debug "Seperating API Data<=========================================================>"
			return words_data
		rescue RestClient::Exception => e
			Rails.logger.debug "Error from Rest Client Itself"+e.inspect
			return []
		end
	end

	def self.get_word_data(word)
		word_data = {}
		word_data["meaning"] = get_word_meaning_from_dictionary(word)
		word_data["top_example"] = get_word_top_example(word)
		word_data["examples"] = get_word_examples(word)
		word_data["definition"] = get_word_definition(word)
		word_data["related_words"] = get_word_related_words(word)
		word_data["pronunciations"] = get_word_pronunciations(word)
		word_data["hyphenation"] = get_word_hyphenation(word)
		return word_data
	end

	def self.get_word_meaning_from_dictionary(word)
		response = RestClient.get "http://www.dictionaryapi.com/api/v1/references/collegiate/xml/#{word}?key=#{get_dictionary_api_key}"
		response = Hash.from_xml(response).to_json
		response = JSON.parse(response)
		Rails.logger.debug "Response for dictionaryapi #{response}"
		if response["entry_list"]["entry"].is_a?(Array)
			response = parse_word_meaning_from_dictionary(response["entry_list"]["entry"][0])
		elsif response["entry_list"]["entry"].is_a?(Hash)
			response = parse_word_meaning_from_dictionary(response["entry_list"]["entry"])
		end	
		return response
	end
	def self.parse_word_meaning_from_dictionary(word_data)
		word_hash = {}
		word_hash["word"] = word_data["id"] unless word_data["id"].nil?
		word_hash["meaning"] = word_data["def"]["dt"] unless word_data["def"]["dt"].nil?
		word_hash["pronunciation"] = word_data["hw"] unless word_data["hw"].nil?
		word_hash["raw_word"] = word_data["pr"] unless word_data["pr"].nil?
		word_hash["word_usage"] = word_data["in"].map{|x| x.values}.flatten	unless word_data["in"].nil?
		word_hash["etymology"] = word_data["et"] unless word_data["et"].nil?
		word_hash["word_types"] = word_data["def"]["uro"].map{|i| {"word"=>i["ure"],"part_of_speech"=>i["fl"]}} unless word_data["def"]["uro"].nil?
		return [word_hash]
	end

	def self.get_word_hyphenation(word)
		response = RestClient.get "http://api.wordnik.com/v4/word.json/#{word}/hyphenation?useCanonical=false&limit=10&api_key=#{get_api_key}"
		Rails.logger.debug "Response for wordnik #{response}"
		response = JSON.parse(response)
		return response
	end

	def self.get_word_pronunciations(word)
		response = RestClient.get "http://api.wordnik.com:80/v4/word.json/#{word}/pronunciations?useCanonical=false&limit=10&api_key=#{get_api_key}"
		Rails.logger.debug "Response for wordnik #{response}"
		response = parse_word_pronunciations(JSON.parse(response))
		return response
	end
	def self.parse_word_pronunciations(word_data)
		words_array = []
		word_data.each do |data|
			word_hash = {}
			word_hash["raw_type"] = data["rawType"]
			word_hash["raw"] = data["raw"]
		end
	end

	def self.get_word_related_words(word)
		response = RestClient.get "http://api.wordnik.com:80/v4/word.json/#{word}/relatedWords?useCanonical=false&limitPerRelationshipType=10&api_key=#{get_api_key}"
		Rails.logger.debug "Response for wordnik #{response}"
		response = parse_word_top_example(JSON.parse(response))
		return response
	end
	def self.parse_word_related_words(word_data)
		words_array = []
		word_data.each do |data|
			word_hash = {}
			word_hash["relationship_type"] = data["relationshipType"]
			word_hash["words"] = data["words"]
			words_array.push(word_hash)
		end
		return word_array
	end

	def self.get_word_top_example(word)
		response = RestClient.get "http://api.wordnik.com:80/v4/word.json/#{word}/topExample?useCanonical=false&api_key=#{get_api_key}"
		Rails.logger.debug "Response for wordnik #{response}"
		response = parse_word_top_example(JSON.parse(response))
		return response
	end
	def self.parse_word_top_example(word)
		words_array = []
		if word.is_a?(Hash)
			word_hash = {}
			word_hash["word"] = word["word"]
			word_hash["title"] = word["title"]
			word_hash["example"] = word["text"]
			words_array.push(word_hash)
		end
		return words_array
	end

	def self.get_word_examples(word)
		response = RestClient.get "http://api.wordnik.com:80/v4/word.json/#{word}/examples?limit=5&includeRelated=true&useCanonical=false&includeTags=false&api_key=#{get_api_key}"
		Rails.logger.debug "Response for wordnik #{response}"
		response = parse_word_examples(JSON.parse(response))
		return response
	end
	def self.parse_word_examples(examples)
		examples_array = []
		examples["examples"].each do |example|
			example_data = {}
			example_data["word"] = example["word"] unless example["word"].nil?
			example_data["title"] = example["title"] unless example["title"].nil?
			example_data["example"] = example["text"] unless example["text"].nil?
			examples_array.push(example_data)
		end
		return examples_array
	end

	def self.get_word_definition(word)
		response = RestClient.get "http://api.wordnik.com:80/v4/word.json/#{word}/definitions?limit=10&includeRelated=true&useCanonical=false&includeTags=false&api_key=#{get_api_key}"
		Rails.logger.debug "Response for wordnik #{response}"
		response = parse_word_definition(JSON.parse(response))
		return response
	end
	def self.parse_word_definition(definition)
		definition_array = []
		definition.each do |data|
			word_data = {}
			word_data["word"] = data["word"] unless data["word"].nil?
			word_data["part_of_speech"] = data["partOfSpeech"] unless data["partOfSpeech"].nil?
			word_data["usage"] = data["text"] unless data["text"].nil?
			definition_array.push(word_data)
		end
		return definition_array
	end

end