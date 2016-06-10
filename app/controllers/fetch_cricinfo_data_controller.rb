class FetchCricinfoDataController < ApplicationController
	def index
		@get_score = JSON.parse(Hash.from_xml(FetchCricinfoDatum.get_score('http://static.cricinfo.com/rss/livescores.xml')).to_json)
		Rails.logger.debug "get_Scores #{@get_score}"
	end
end
