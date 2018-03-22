#!/bin/sh

root_dir=$1
bitdepthflag=$2
root_dir=~/Dev/vp9d

build_dir=$root_dir/release

if [ "$bitdepthflag" = "highbitdepth" ]; then
  build_flag="--enable-vp9-highbitdepth"
else
  build_flag=
fi

cd $build_dir
rm -r -f *
make clean > /dev/null

build_flag="--enable-vp9-highbitdepth"
common_flag="--enable-pic --disable-unit-tests --disable-docs"

/usr/local/google/home/nguyennancy/Dev/vp9d/libvpx/configure $common_flag $build_flag > /dev/null

make -j > /dev/null
if [ $? -ne 0 ]; then
  echo "VP9 build failed"
  exit 1
fi

test_dir=~/Dev/nightly

cp -f ./vpxenc $test_dir/.
cp -f ./vpxdec $test_dir/.
