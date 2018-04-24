#!/bin/sh
#
#
# UBSAN x86-linux-gcc, integer

cd ~/release
echo -e "\033[5;31;47mWARNING MESSAGE\033[0m"
read -p "CMake removes all old configurations in your local directory. Do you wish to continue (y/n)?" CONT

if [ "$CONT" = "y" ]; then
  rm -r -f * 
  arch=x86-linux-gcc
  find /opt/clang-5.0.1/lib -name libclang_rt.builtins-i386.a -print -quit
  clang_rt=/opt/clang-5.0.1/lib/clang/5.0.1/lib/linux/libclang_rt.builtins-i386.a
  echo extralibs += /opt/clang-5.0.1/lib/clang/5.0.1/lib/linux/libclang_rt.builtins-i386.a
  toolchain_file=../aom/build/cmake/toolchains/x86-linux.cmake

  cmake ../aom -DSANITIZE=integer -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_C_FLAGS=-O1 -DCMAKE_CXX_FLAGS=-O1 -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXE_LINKER_FLAGS="-Wl,--start-group /opt/clang-5.0.1/lib/clang/5.0.1/lib/linux/libclang_rt.builtins-i386.a" -DCMAKE_TOOLCHAIN_FILE=../aom/build/cmake/toolchains/x86-linux.cmake -DENABLE_CCACHE=1

  make test_libaom test_intra_pred_speed && make testdata

  ./test_libaom --gtest_filter=-:*/DatarateTest*Large*:*/ErrorResilienceTestLarge*

else
  exit;
fi
