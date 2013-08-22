#!/bin/bash
echo "scale=2; `curl  --progress-bar -w "%{speed_download}" http://speedtest.wdc01.softlayer.com/downloads/test10.zip -o /home/primo/www/hdp-dashing/tmpfiles/test.zip` / 131072" | bc | xargs -I {} echo {} > /home/primo/www/hdp-dashing/tmpfiles/speed
