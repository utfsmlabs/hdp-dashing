require 'net/http'

SCHEDULER.every '1m', :first_in => 0 do |job|
	primos = Hash.new
	html = Net::HTTP.get(URI.parse('http://ctm.inf.santiago.usm.cl/pdts')).force_encoding('utf-8')
	primos_arreglo = html.split(',')

	primos_arreglo.each do |primo|
		primos[primo] = { label: primo }
	end

    primos.values.each do |primo|
	  if primo.label == 'Fuera del horario de turnos'
	    primo.label = ''
	  end    
      send_event('primos', { primos: primos.values })
	end
end