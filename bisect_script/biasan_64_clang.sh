#!/bin/bash

aom_dir=~/bisectav1/aom
testcase_dir=~/bisect

cd $aom_dir
pwd

echo -n "Enter the git bisect bad commit: " 
read  badcommit

echo -n "Enter the git bisect good commit: " 
read  goodcommit
git bisect reset
git pull
git bisect start
git bisect bad $badcommit
git bisect good $goodcommit

$testcase_dir/testcase.sh

git bisect run ~/bisect/rv.sh ~/bisect/asan_64_clang_cmake.sh

cd ~/bisect
rm testcase.txt
