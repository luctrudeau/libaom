#!/bin/bash

build_dir=~/bisectav1/build

cd $build_dir

echo "*********************************"\n 
echo "Enter the failed unittest:"
read testcase  
echo $testcase >> /usr/local/google/home/nguyennancy/bisect/testcase.txt
