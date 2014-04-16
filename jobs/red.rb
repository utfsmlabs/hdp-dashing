# Populate the graph with some random points
points = []
(1..10).each do |i|
  points << { x: i, y: rand(15) }
end
last_x = points.last[:x]

SCHEDULER.every '1m' do
  points.shift
  last_x += 1
  speed = `/usr/bin/time -f '%e' curl -s http://download.thinkbroadband.com/10MB.zip -o /dev/null 2>&1`  
  speed.slice! "\n"
  vel = speed.to_f
  points << { x: last_x, y: vel }
  send_event('red', points: points)
end
