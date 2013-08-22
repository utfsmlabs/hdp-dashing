# Populate the graph with some random points
points = []
(1..10).each do |i|
  points << { x: i, y: rand(15) }
end
last_x = points.last[:x]

SCHEDULER.every '5m' do
  points.shift
  last_x += 1
  f = File.open("/home/primo/www/hdp-dashing/tmpfiles/speed")
  vel = f.gets.to_f
  f.close
  points << { x: last_x, y: vel }
  puts points
  send_event('red', points: points)
end
