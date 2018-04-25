#!/bin/sh

root_dir=$1
build_dir=$root_dir/release
script_dir=~/Devtest/sandbox/aom/test_scripts
exp_tool=

cd $build_dir
make clean > /dev/null
#rm -r -f *
rm -fr *
$script_dir/aom_nightly_config.sh
make -j > /dev/null
if [ $? -ne 0 ]; then
  echo "AV1 build failed!"
  exit 1
fi

test_dir=~/Devtest/nightly

cp -f ./aomenc $test_dir/.
cp -f ./aomdec $test_dir/.
