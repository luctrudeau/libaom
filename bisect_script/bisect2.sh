#!/bin/bash

testcase=AV1/ErrorResilienceTestLarge.ParseAbilityTest/1
aom_dir=~/bisectav1/aom
testcase_dir=~/bisect

cd $aom_dir
pwd

echo -n "Enter the bad commit head: " 
read  badcommit

echo -n "Enter the good commit head: " 
read  goodcommit
git pull
git bisect start
git bisect bad $badcommit
git bisect good $goodcommit

$testcase_dir/testcase.sh

git bisect run ~/bisect/bisecttest.sh
