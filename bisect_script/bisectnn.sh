!/bin/bash

aom_dir=~/bisectav1/aom
testcase_dir=~/bisect

cd $aom_dir
pwd

echo -n "Enter the git bisect bad commit: " 
read  badcommit

echo -n "Enter the git bisect good commit: " 
read  goodcommit
git pull
git bisect start
git bisect bad $badcommit
git bisect good $goodcommit

$testcase_dir/testcase.sh

git bisect run ~/bisect/rv.sh ~/bisect/bisect_ubsan_int.sh

