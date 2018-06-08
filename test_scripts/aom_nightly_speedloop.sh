#!/bin/sh
# File:
#  nightly_speed.sh
# Decription:
#  Configure, build, and run AV1 encoder/decoder for each experimental tool.
#  Display the encoder/decode run time
# Preassumption:
#  1) Assume all script files are in ~/Devtest/sandbox/aom/test_scripts
# Note:
#  See encoder config output if set,
#  verbose=-v
set -x

root_dir=~/Devtest/av1d

log_path=~/Devtest/log

if [ "$bd" == "10" ]; then
  bitdepth="--bit-depth=10"
fi

if [ "$bd" == "8" ]; then
  bitdepth=
fi

code_dir=$root_dir/aom
build_dir=$root_dir/release
test_dir=~/Devtest/nightly
script_dir=~/Devtest/sandbox/aom/test_scripts

if [ "$bd" == "10" ]; then
. $script_dir/speedloop2.sh
fi

if [ "$bd" == "8" ]; then
. $script_dir/speedloop1.sh
fi

codec="--codec=av1"
verbose=
core_id=1
exp_tool=experimental
bd=8
speed=1

cd $root_dir/aom
commit=`git log --pretty=%h -1`

profile=0
tune_content=
col_num=0
laginframes=19
video=~/Devtest/samples/videos/midres/BasketballDrill_832x480_50.y4m
frames=2
bitrate=800
fps="50/1"

elog=av1enc_log_p_$profile.$bd.$speed.txt
dlog=av1dec_log_p_$profile.$bd.$speed.txt
bstream=av1_p_$profile.$speed.$bd.$commit.webm

cd ~/Devtest/av1d/release

./aomenc $verbose -o /dev/shm/"$bstream" $video $codec --fps=$fps --skip=0 -p 2 --cpu-used=$speed --target-bitrate=$bitrate --lag-in-frames=$laginframes --profile=$profile $bitdepth --limit=$frames --enable-cdef=0 --min-q=0 --max-q=63 --auto-alt-ref=1 --kf-max-dist=150 --kf-min-dist=0 --drop-frame=0 --static-thresh=0 --bias-pct=50 --minsection-pct=0 --maxsection-pct=2000 --arnr-maxframes=7 --arnr-strength=5 --sharpness=0 --undershoot-pct=100 --overshoot-pct=100 --frame-parallel=0 -t 1 --psnr --test-decode=warn -D &>> $elog
