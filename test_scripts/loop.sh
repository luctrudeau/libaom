#!/bin/bash

for i in {1..20};
do
  taskset -c 1 ~/Dev/av1d/release/aomdec /dev/shm/av1_p_0.1.8.d6499b0cd.webm --codec=av1 --i420 --noblit --summary &>> ~/Dev/nightly/output.txt
done

output_dir=~/Dev/nightly

awk '{print $9}' <~/Dev/nightly/output.txt &>>~/Dev/nightly/output2.txt
echo | sed 's/(//' <~/Dev/nightly/output2.txt &>>~/Dev/nightly/output3.txt
awk '{ total += $1; count++ } END { print total/count }' ~/Dev/nightly/output3.txt &>>~/Dev/nightly/sum.txt
awk '{print $1}' < ~/Dev/nightly/sum.txt
