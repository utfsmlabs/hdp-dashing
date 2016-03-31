require 'icalendar'

ical_url = 'https://calendar.google.com/calendar/ical/primos.stgo%40gmail.com/private-c9b51ef374fb7fb37deebe810e97d069/basic.ics'
uri = URI ical_url

Encoding.default_external = Encoding::UTF_8

SCHEDULER.every '15s', :first_in => 4 do |job|
  result = Net::HTTP.get uri

  calendars = Icalendar.parse(result.force_encoding("utf-8"))
  calendar = calendars.first

  events = calendar.events.map do |event|
    {
      start: event.dtstart,
      end: event.dtend,
      summary: event.summary
    }
  end.select { |event| event[:start] > DateTime.now }

  events = events.sort { |a, b| a[:start] <=> b[:start] }

  events = events[0..5]

  send_event('google_calendar', { events: events })
end
