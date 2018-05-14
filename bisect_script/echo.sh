#!/bin/bash

build_dir=~/bisectav1/build

cd $build_dir

echo -n "Enter the testcase to be bisected: " 
read testcase  
echo $testcase >> testcase.txt
