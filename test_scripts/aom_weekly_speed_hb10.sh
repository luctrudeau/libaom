#!/bin/sh
#set -x

log_path=~/Devtest/log
html_log_file=aomencwk.html


bd=10
speed=1
frames=2
bitrate=2500
#bitrate=9000
profile=0
date=`date +%b_%d_%Y`
av1_code=~/Devtest/av1w

cd $av1_code/aom
commit=`git log --pretty=%h -1`

elog_dir=~/Devtest/weekly
elog=$elog_dir/av1encw_p.0.$bd.$speed.$commit.txt
dlog=$elog_dir/av1decw_p.0.$bd.$speed.$commit.txt

script_path=~/Devtest/sandbox/aom/test_scripts

build_dir=~/Devtest/av1w/release
cd $build_dir
bstream=crowd_run_1080p_$commit.$bd.$speed.f$frames.webm

taskset -c 0 ./aomenc -o /run/shm/$bstream ~/Devtest/samples/videos/speed-set/crowd_run_1080p_10.y4m --codec=av1 --fps=30/1 --skip=0 -p 2 --cpu-used=$speed --target-bitrate=$bitrate --lag-in-frames=19 --profile=$profile --bit-depth=$bd --limit=$frames --enable-cdef=0 --min-q=0 --max-q=63 --auto-alt-ref=1 --kf-max-dist=150 --kf-min-dist=0 --drop-frame=0 --static-thresh=0 --bias-pct=50 --minsection-pct=0 --maxsection-pct=2000 --arnr-maxframes=7 --arnr-strength=5 --sharpness=0 --undershoot-pct=100 --overshoot-pct=100 --frame-parallel=0 -t 1 --psnr --test-decode=warn -D &>> $elog

taskset -c 1 ./aomdec /run/shm/$bstream --codec=av1 --i420 --noblit --summary 2>&1 &>> $dlog

bs_dir=/run/shm
cd $bs_dir
wc=`cat $bstream | wc -c`

etime=`cat $elog | awk 'NR==2 {NF-=3; print $NF}'`
dtime=`cat $dlog | awk 'NR==1 {NF-=3; print $NF}'`
dfps=`awk '{print $9}' < $dlog`
dfps=`echo $dfps | sed 's/(//'`

vp9enctime=2431758
ev1v9time=`echo "($etime / $vp9enctime)" | bc -l`
ev1v9time=${ev1v9time:0:5}

vp9dectime=2747652
dv1v9time=`echo "($dtime / $vp9dectime)" | bc -l`
dv1v9time=${dv1v9time:0:5}

psnr=`cat $elog | grep 'PSNR' | awk '{print $5, $6, $7, $8, $9}'`

data=https://docs.google.com/spreadsheets/d/1kstmSOkTeo92hBAjXg9AICkrjc3_dnSt0poWmssqAd0
graph=https://docs.google.com/spreadsheets/d/1aNcHCOX606w-kVNURfsH8sNxZuDSnIcmzDl_jEKOg9U

echo "<table style=\"width:100%\">" >> $log_path/$html_log_file
echo "  <tr style="color:blue" bgcolor="#FAF988">" >> $log_path/$html_log_file
echo "    <th style="text-align:center" colspan=\"8\"> WEEKLY SPEED REPORT </th>" >> $log_path/$html_log_file
echo "  </tr>" >> $log_path/$html_log_file
echo "    <th style="color:green" colspan=\"8\">AV1: crowd_run_1080p_10.y4m bitrate=$bitrate profile=$profile frames=$frames </th>" >> $log_path/$html_log_file
echo "  <tr>" >> $log_path/$html_log_file
echo "    <th>Enc Time (ms)</th>" >> $log_path/$html_log_file
echo "    <th>Enc Time (x) VP1 vs VP9</th>" >> $log_path/$html_log_file
echo "    <th>Dec Time (us)</th>" >> $log_path/$html_log_file
echo "    <th>Dec FPS</th>" >> $log_path/$html_log_file
echo "    <th>Dec Time (x) VP1 vs VP9</th>" >> $log_path/$html_log_file
echo "    <th>Speed</th>" >> $log_path/$html_log_file
echo "    <th>bit-depth</th>" >> $log_path/$html_log_file
echo "    <th>bstream size</th>" >> $log_path/$html_log_file
echo " </tr>" >> $log_path/$html_log_file
echo " <tr>" >> $log_path/$html_log_file
echo "    <td>$etime</td>" >> $log_path/$html_log_file
echo "    <td>$ev1v9time</td>" >> $log_path/$html_log_file
echo "    <td>$dtime</td>" >> $log_path/$html_log_file
echo "    <td>$speed</td>" >> $log_path/$html_log_file
echo "    <th>$bd</th>" >> $log_path/$html_log_file
echo "    <td>$wc</td>" >> $log_path/$html_log_file
echo "  </tr>" >> $log_path/$html_log_file
echo "  <tr>" >> $log_path/$html_log_file
echo "    <td colspan=\"8\">bitstream folder: /cns/yv-d/home/on2-prod/nguyennancy/Weekly/$bstream" >> $log_path/$html_log_file
echo " </tr>" >> $log_path/$html_log_file
echo "  <tr>" >> $log_path/$html_log_file
echo "    <td colspan=\"8\">PSNR $psnr" >> $log_path/$html_log_file
echo " </tr>" >> $log_path/$html_log_file
echo "  <tr>" >> $log_path/$html_log_file
echo "    <td colspan=\"8\">Note: VP9_enc_time=2431758, VP9_dec_time=2747652" >> $log_path/$html_log_file
echo " </tr>" >> $log_path/$html_log_file
echo "</table>" >> $log_path/$html_log_file
echo " <br style=\"width:100%\">" >> $log_path/$html_log_file
echo " <br style=\"width:100%\">" >> $log_path/$html_log_file

cp $elog $log_path
cp $dlog $log_path

echo " <br style=\"width:100%\">" >> $log_path/$html_log_file
echo "<p style="color:green">Note: AV1 Weekly Speed Data:$data</p>" >> $log_path/$html_log_file
echo "<p style="color:green">Note: AV1 Weekly Speed Graph:$graph</p>" >> $log_path/$html_log_file

#fileutil cp /run/shm/"$bstream" /cns/yv-d/home/on2-prod/nguyennancy/Weekly/.
