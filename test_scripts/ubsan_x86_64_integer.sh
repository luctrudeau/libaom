#!/bin/sh
#
#
# UBSAN x86-linux-gcc, integer

cd ~/release

echo -e "\033[5;31;47mWARNING MESSAGE\033[0m"
read -p "CMake removes all old configurations in your local directory. Do you wish to continue (y/n)?" CONT

if [ "$CONT" = "y" ]; then
  rm -r -f * 

  cmake ../aom -DSANITIZE=integer -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_C_FLAGS=-O1 -DCMAKE_CXX_FLAGS=-O1 -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXE_LINKER_FLAGS=-Wl,--start-group  -DENABLE_CCACHE=1

  make test_libaom test_intra_pred_speed && make testdata
  
  ./test_libaom 

else
  exit;
fi
