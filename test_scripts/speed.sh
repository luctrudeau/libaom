#!/bin/bash


cd ~/Devtest/av1d/release

speeds=( 0 1 )

for speed in ${speeds[@]}
do
#echo --AV1 $bd bit depth--
# run encoder


./aomenc -o /dev/shm/speed_$speed.webm ~/Devtest/samples/videos/midres/BasketballDrill_832x480_50.y4m  --codec=av1 --fps=50/1 --skip=0 -p 2 --cpu-used=$speed --target-bitrate=800 --lag-in-frames=19 --profile=0 --bit-depth=10 --limit=2 --enable-cdef=0 --min-q=0 --max-q=63 --auto-alt-ref=1 --kf-max-dist=150 --kf-min-dist=0 --drop-frame=0 --static-thresh=0 --bias-pct=50 --minsection-pct=0 --maxsection-pct=2000 --arnr-maxframes=7 --arnr-strength=5 --sharpness=0 --undershoot-pct=100 --overshoot-pct=100 --frame-parallel=0 -t 1 --psnr --test-decode=warn -D &>>/tmp/speedlog.txt

done
