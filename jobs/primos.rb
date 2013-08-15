primos = Hash.new

SCHEDULER.every '1m', :first_in => 0 do |job|
	html = Net::HTTP.get(URI.parse('http://ctm.inf.santiago.usm.cl/pdts')).force_encoding('utf-8')
	primos_arreglo = html.split(',')

	primos_arreglo.each do |primo|
		primos[primo] = { label: primo }
	end

	send_event('primos', { items: primos.values })
end