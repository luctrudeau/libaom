#!/bin/sh
#
#
# ASAN x86-linux-clang

build_dir=~/bisectav1/build

cd $build_dir

#read testcase


cd $build_dir
rm -r -f *

cmake ../aom -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_C_FLAGS_RELEASE="-O3 -g" -DCMAKE_CXX_FLAGS_RELEASE="-O3 -g" -DCMAKE_LD_FLAGS_RELEASE="-O3 -g" -DENABLE_CCACHE=1 -DSANITIZE=address -DCMAKE_TOOLCHAIN_FILE=../aom/build/cmake/toolchains/x86-linux.cmake -DCONFIG_LOWBITDEPTH=0

make -j12 && make testdata

ASAN_OPTIONS=
ASAN_OPTIONS=:handle_segv=0
ASAN_OPTIONS=:handle_segv=0:abort_on_error=1
ASAN_OPTIONS=:handle_segv=0:abort_on_error=1:fast_unwind_on_fatal=1
ASAN_OPTIONS=:handle_segv=0:abort_on_error=1:fast_unwind_on_fatal=1:detect_stack_use_after_return=1
ASAN_OPTIONS=:handle_segv=0:abort_on_error=1:fast_unwind_on_fatal=1:detect_stack_use_after_return=1:max_uar_stack_size_log=17
ASAN_OPTIONS=:handle_segv=0:abort_on_error=1:fast_unwind_on_fatal=1:detect_stack_use_after_return=1:max_uar_stack_size_log=17:allocator_may_return_null=1
export ASAN_OPTIONS

cd ~/bisect

cat testcase.txt > ~/bisectav1/build/case

cd ~/bisectav1/build
tc=$(cat "case")

./test_libaom --gtest_filter=$tc
