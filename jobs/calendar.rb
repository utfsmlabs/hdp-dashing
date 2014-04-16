# -*- encoding : utf-8 -*-
#!/usr/bin/env ruby
require 'open-uri'
require 'nokogiri'
require 'date'
require 'cgi'

settings = YAML.load_file("config.yaml")

# Config
# make sure your URLs end with /full, not /simple (which is default)!
# ------
calendars = [{name:'LPA (B-044)', url: settings["config"]["calendar_1"]},
        {name: 'Sala Feria (B-038)', url: settings["config"]["calendar_2"]}]
events = Array.new

SCHEDULER.every '10m', :first_in => 0 do |job|
	events = Array.new
	min = CGI.escape(DateTime.now().to_s)
	max = CGI.escape((DateTime.now()+7).to_s)
	
	calendars.each do |calendar|
		url = calendar[:url]+"?singleevents=true&orderby=starttime&start-min=#{min}&start-max=#{max}"
		reader = Nokogiri::XML(open(url))
		reader.remove_namespaces!
		reader.xpath("//feed/entry").each do |e|
			title = e.at_xpath("./title").text
			content = e.at_xpath("./content").text
			when_node = e.at_xpath("./when")
			events.push({title: title,
				body: content ? content : "",
				calendar: calendar[:name],
				when_start_raw: when_node ? DateTime.iso8601(when_node.attribute('startTime').text).to_time.to_i : 0,
				when_end_raw: when_node ? DateTime.iso8601(when_node.attribute('endTime').text).to_time.to_i : 0,
				when_start: when_node ? DateTime.iso8601(when_node.attribute('startTime').text).to_s : "No time",
				when_end: when_node ? DateTime.iso8601(when_node.attribute('endTime').text).to_s : "No time"
			})
		end
	end

	events.sort! { |a,b| a[:when_start_raw] <=> b[:when_start_raw] }
	events = events.slice!(0,15) # 15 elements is probably enough...
	
	send_event('calendar_events', { events: events })
end

SCHEDULER.every '1m', :first_in => 0 do |job|
	events_tmp = Array.new(events)
	events_tmp.delete_if{|event| DateTime.now().to_time.to_i>=event[:when_end_raw]}
	
		
	if events_tmp.count != events.count
		events = events_tmp
		send_event('calendar_events', { events: events })
	end
end
