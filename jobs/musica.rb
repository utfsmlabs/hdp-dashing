require 'open-uri'
# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '5s', :first_in => 0 do |job|  	
	url = "http://localhost:9000/player/command.php?currentsong"
	response = JSON.parse (open(url).read.gsub(/[()]/,""))
	#puts response
	cancion = response['result']['Artist'].to_s + " - " + response['result']['Title'].to_s
	#puts cancion
	send_event('musica', { text: cancion })
end
