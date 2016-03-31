# -*- encoding : utf-8 -*-
require 'unirest'

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '10s', :first_in => 0 do |job|  	
	response = Unirest.post "http://raspberry.inf.santiago.usm.cl:6680/mopidy/rpc", 
	                        headers:{ "Content-Type" => "application/json" }, 
	                        parameters:{
										  :method => "core.playback.get_current_track",
										  :jsonrpc => "2.0",
										  :params => {},
										  :id => 1
										}.to_json

	

		cancion = response.body["result"]["name"]
		artist = response.body["result"]["album"]["artists"][0]["name"]
		send_event('musica', { title: artist, text: cancion})

end
