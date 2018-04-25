#!/bin/sh
#set -x

build_dir=~/Devtest/av1w/release
cd $build_dir
rm -r -f *
echo "cmake ../aom -DCONFIG_UNIT_TESTS=0 -DENABLE_DOCS=0 --DCONFIG_LOWBITDEPTH=1"

cmake ../aom -DCONFIG_UNIT_TESTS=0 -DENABLE_DOCS=0 -DCONFIG_LOWBITDEPTH=1 > /dev/null 2>&1
make -j > /dev/null

if [ $? -ne 0 ]; then
  echo "Error: cmake configure fails!" > $test_dir/aom_error_config.txt
  exit 1
fi
