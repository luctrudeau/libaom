#!/bin/sh
#
#
# UBSAN x86-linux-gcc, integer

cd ~/release

echo -e "\033[5;31;47mWARNING MESSAGE\033[0m"
read -p "CMake removes all old configurations in your local directory. Do you wish to continue (y/n)?" CONT

if [ "$CONT" = "y" ]; then
  rm -r -f * 

  cmake ../aom/ -DENABLE_CCACHE=1 -DENABLE_DOCS=0 -DCONFIG_UNIT_TESTS=1 -DCMAKE_C_FLAGS_RELEASE=-O3 -DCMAKE_CXX_FLAGS_RELEASE=-O3 -DCONFIG_LOWBITDEPTH=1 -DCMAKE_TOOLCHAIN_FILE=../aom/build/cmake/toolchains/x86-linux.cmake

  make test_libaom && make testdata

  valgrind --leak-check=full --show-reachable=yes --error-exitcode=1 ./test_libaom --gtest_filter=-*Large*:AV1/CpuSpeedTest.*:AV1/BordersTest.*

else
  exit;
fi
