class FetchCricinfoDatum < ApplicationRecord
	def self.get_score(url)
		return Net::HTTP.get(URI.parse(url))
	end
end
