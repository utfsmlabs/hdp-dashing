reunion = Hash.new
reunion["reunion"] = {label: "Hay mas primos de turno que pokemones!" }

SCHEDULER.every '1m', :first_in => 0 do |job|
	primos = Hash.new
	html = Net::HTTP.get(URI.parse('http://ctm.inf.santiago.usm.cl/pdts')).force_encoding('utf-8')
	primos_arreglo = html.split(',')

	primos_arreglo.each do |primo|
		primos[primo] = { label: primo }
	end
	if primos.count < 5
		send_event('primos', { items: primos.values })
	else
		send_event('primos', { items: reunion.values })
	end
end
