# -*- encoding : utf-8 -*-
require 'unirest'

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '10s', :first_in => 0 do |job|  	
	response = Unirest.post "http://bender:9000/mopidy/rpc", 
	                        headers:{ "Content-Type" => "application/json" }, 
	                        parameters:{
										  :method => "core.playback.get_current_track",
										  :jsonrpc => "2.0",
										  :params => {},
										  :id => 1
										}.to_json

	cancion = response.body["result"]["name"]

	send_event('musica', { title: "Reproduciendo", text: response.body["result"]["name"]})

=begin
	if cancion
		send_event('musica', { title: response.body["result"]["name"].to_s, text: "test".to_s})
	else
		send_event('musica', { title: "", text: "Aqui pondria el nombre de la cancion.  \n\n Si tuviera una!" })
	end
=end
end
