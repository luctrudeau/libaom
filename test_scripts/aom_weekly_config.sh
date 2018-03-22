#!/bin/sh
#set -x

libsrc=aom
test_dir=~/Dev/weekly

#echo "cmake ../$libsrc -DCONFIG_UNIT_TESTS=0 -DENABLE_DOCS=0 -DCONFIG_EXPERIMENTAL=1 -DCONFIG_LOWBITDEPTH=1"

/usr/local/bin/cmake ../$libsrc -DCONFIG_UNIT_TESTS=0 -DENABLE_DOCS=0 -DCONFIG_EXPERIMENTAL=1 -DCONFIG_LOWBITDEPTH=1 > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Error: cmake configure fails!" > $test_dir/aom_error_config.txt
  exit 1
fi
