#!/bin/sh
#
#
# UBSAN x86-linux-gcc, integer

cd ~/release

echo -e "\033[5;31;47mWARNING MESSAGE\033[0m"
read -p "CMake removes all old configurations in your local directory. Do you wish to continue (y/n)?" CONT

if [ "$CONT" = "y" ]; then
  rm -r -f * 

  cmake ../aom -DSANITIZE=thread -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_C_FLAGS=-O2 -DCMAKE_CXX_FLAGS=-O2 -DCMAKE_BUILD_TYPE=Debug -DENABLE_CCACHE=1 -DCONFIG_LOWBITDEPTH=1

  make test_libaom && make testdata

  TSAN_OPTIONS=
  TSAN_OPTIONS= handle_sigfpe=1
  TSAN_OPTIONS= handle_sigfpe=1 handle_segv=1
  TSAN_OPTIONS= handle_sigfpe=1 handle_segv=1 handle_abort=1
  export TSAN_OPTIONS

  ./test_libaom --gtest_filter=*Thread*:-*Large*

else
  exit;
fi
