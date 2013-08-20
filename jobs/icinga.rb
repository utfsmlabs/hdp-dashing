SCHEDULER.every '1m', :first_in => 0 do |job|
	send_event('widget_id', { })
end