#!/bin/sh
#
#
# UBSAN x86-linux-gcc, integer

cd ~/release

echo -e "\033[5;31;47mWARNING MESSAGE\033[0m"
read -p "CMake removes all old configurations in your local directory. Do you wish to continue (y/n)?" CONT

if [ "$CONT" = "y" ]; then
  rm -r -f * 

  cmake ../aom -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_C_FLAGS_RELEASE="-O3 -g" -DCMAKE_CXX_FLAGS_RELEASE="-O3 -g" -DCMAKE_LD_FLAGS_RELEASE="-O3 -g" -DENABLE_CCACHE=1 -DSANITIZE=address -DCONFIG_LOWBITDEPTH=0

  make -j2 VERBOSE=1 && make testdata

  ASAN_OPTIONS=
  ASAN_OPTIONS=:handle_segv=0
  ASAN_OPTIONS=:handle_segv=0:abort_on_error=1
  ASAN_OPTIONS=:handle_segv=0:abort_on_error=1:fast_unwind_on_fatal=1
  ASAN_OPTIONS=:handle_segv=0:abort_on_error=1:fast_unwind_on_fatal=1:detect_stack_use_after_return=1
  ASAN_OPTIONS=:handle_segv=0:abort_on_error=1:fast_unwind_on_fatal=1:detect_stack_use_after_return=1:max_uar_stack_size_log=17
  ASAN_OPTIONS=:handle_segv=0:abort_on_error=1:fast_unwind_on_fatal=1:detect_stack_use_after_return=1:max_uar_stack_size_log=17:allocator_may_return_null=1
  export ASAN_OPTIONS

  ./test_libaom --gtest_output=xml


else
  exit;
fi
