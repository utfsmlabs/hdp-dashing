# -*- encoding : utf-8 -*-
# Populate the graph with some random points
points = []
(1..10).each do |i|
  points << { x: i, y: rand(15) }
end
last_x = points.last[:x]

SCHEDULER.every '5m' do
  points.shift
  last_x += 1
  speed = `/usr/bin/time -f '%e' curl -s http://web4host.net/5MB.zip -o /dev/null 2>&1`  
  speed = /\d+.\d+/.match(speed).to_s.to_f
  vel = 5120/speed.to_f
  vel = vel.to_i
  points << { x: last_x, y: vel }
  send_event('red', points: points)
end