#!/bin/env ruby
# encoding: utf-8

require 'net/http'

SCHEDULER.every '1m', :first_in => 0 do |job|
	primos = Hash.new
	html = Net::HTTP.get(URI.parse('http://ctm.inf.santiago.usm.cl/pdts')).force_encoding('utf-8')
	primos_hash = ""
	eval("primos_hash ="+html)

	if primos_hash.empty?
		primos[primo] = {label: "Fuera del"}
		primos[primo] = {label: "Horario"}
		primos[primo] = {label: "de Turnos"}
	end

	primos_hash.each do |primo, log|
		primos[primo] = { label: primo }
		if log
			primos[primo] = { label: primo , icon: "✓"}
		else
			primos[primo] = { label: primo , icon: "x"}
		end
	end
	
	# primos_arreglo.each do |primo|
	# 	if primo == "Fuera del horario de turnos"
	# 		primos[primo] = {label: "Fuera del"}
	# 		primos[primo] = {label: "Horario"}
	# 		primos[primo] = {label: "de Turnos"}

	# 	else
	# 		primos[primo] = { label: primo }
	# 	end
	# end

    send_event('primos', { primos: primos.values })
end