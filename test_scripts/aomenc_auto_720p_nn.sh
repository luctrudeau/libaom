#!/bin/sh
# Unique calling argument: frame number
#
#set -x

if [ "$#" -ne 1 ]; then
  frames=2
else
  frames=$1
fi

prof=0

#speeds=( 0 1 )
speeds=( 1 )
bd=8

for speed in ${speeds[@]}
do
echo --AV1 $speed cpu-used-- $bd bit depth--
cd /usr/local/google/home/nguyennancy/Dev/av1w/aom

#git pull
commithash=`git log --pretty=%h -1`
cd /usr/local/google/home/nguyennancy/Dev/av1w/release
# run encoder

# In a release direcotry
#cd /usr/local/google/home/nguyennancy/Dev/av1w/aom
#git pull
#commithash=`git log --pretty=%h -1`
#cd /usr/local/google/home/nguyennancy/Dev/av1w/release

#../aom/configure --disable-docs --disable-unit-tests
#make clean;make

rm -r  -f *
cmake ../aom -DCONFIG_UNIT_TESTS=0 -DENABLE_DOCS=0
#cmake ../aom -DCONFIG_UNIT_TESTS=0 -DENABLE_DOCS=0
make -j

fps=30
bitrate=2500
laginframes=19
date_str=`date +%b_%d_%Y`
bitstream=night_720p30_av1_$commithash.$date_str.$bd.$speed.f$frames.webm

taskset -c 0 ./aomenc -o /run/shm/$bitstream ~/Dev/samples/videos/speed-set/night_720p30.y4m --codec=av1 --fps=$fps/1 --skip=0 -p 2 --cpu-used=$speed --target-bitrate=$bitrate --lag-in-frames=$laginframes --profile=$prof --bit-depth=$bd --limit=$frames --enable-cdef=0 --min-q=0 --max-q=63 --auto-alt-ref=1 --kf-max-dist=150 --kf-min-dist=0 --drop-frame=0 --static-thresh=0 --bias-pct=50 --minsection-pct=0 --maxsection-pct=2000 --arnr-maxframes=7 --arnr-strength=5 --sharpness=0 --undershoot-pct=100 --overshoot-pct=100 --frame-parallel=0 -t 1 --psnr --test-decode=warn -D
done
