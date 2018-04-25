#!/bin/sh

aom_dir=~/Devtest/av1w/aom
cd $aom_dir

git checkout -q master
git pull -q
git log -1 --oneline
