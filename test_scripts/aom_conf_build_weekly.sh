#!/bin/sh

root_dir=$1
build_dir=$root_dir/release
script_dir=~/Dev/sandbox/libvpx/scripts
exp_tool=

cd $build_dir
make clean > /dev/null
#rm -r -f *
rm -fr *
$script_dir/aom_weekly_config.sh
make -j > /dev/null
if [ $? -ne 0 ]; then
  echo "AV1 build failed!"
  exit 1
fi

test_dir=~/Dev/weekly

cp -f ./aomenc $test_dir/.
cp -f ./aomdec $test_dir/.
