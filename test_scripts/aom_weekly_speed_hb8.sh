#!/bin/sh
# File:
#  nightly_speed.sh
# Decription:
#  Configure, build, and run AV1 encoder/decoder for each experimental tool.
#  Display the encoder/decode run time
# Preassumption:
#  1) Assume all script files are in ~/Dev/sandbox/libvpx/scripts
# Note:
#  See encoder config output if set,
#  verbose=-v
#set -x

if [ "$#" -ne 6 ]; then
  root_dir=~/Dev/av1w
  pdfps=1
  petime=1
  speed=0
  html_log_file=log.html  
else
  root_dir=$1
  pdfps=$2
  petime=$3
  speed=$4
  bd=$5
  html_log_file=$6
fi
log_path=~/Dev/log

if [ "$bd" == "10" ]; then
  bitdepth="--bit-depth=10"
fi

if [ "$bd" == "8" ]; then
  bitdepth=
fi

code_dir=$root_dir/aom
build_dir=$root_dir/release
test_dir=~/Dev/weekly
script_dir=~/Dev/sandbox/libvpx/scripts

if [ "$bd" == "10" ]; then
. $script_dir/crowd_1080.sh
fi

if [ "$bd" == "8" ]; then
. $script_dir/night_720.sh
fi

# General options
codec="--codec=av1"
verbose=
core_id=1
exp_tool=experimental

cd $root_dir/aom
commit=`git log --pretty=%h -1`

cd $test_dir

profile=0
tune_content=
col_num=0
laginframes=19

elog=av1encw_log_p_$profile.$bd.$speed.txt
dlog=av1decw_log_p_$profile.$bd.$speed.txt
bstream=av1w_p_$profile.$speed.$bd.$commit.webm

taskset -c $core_id ./aomenc $verbose -o /run/shm/"$bstream" $video $codec --fps=$fps --skip=0 -p 2 --cpu-used=$speed --target-bitrate=$bitrate --lag-in-frames=$laginframes --profile=$profile $bitdepth --limit=$frames --enable-cdef=0 --min-q=0 --max-q=63 --auto-alt-ref=1 --kf-max-dist=150 --kf-min-dist=0 --drop-frame=0 --static-thresh=0 --bias-pct=50 --minsection-pct=0 --maxsection-pct=2000 --arnr-maxframes=7 --arnr-strength=5 --sharpness=0 --undershoot-pct=100 --overshoot-pct=100 --frame-parallel=0 -t 1 --psnr --test-decode=warn -D &>>$elog

# Note: $2 is the time unit, ms or us
etime=`cat $elog | awk 'NR==2 {NF-=3; print $NF}'`
# efps=`cat $elog | grep 'Pass 2/2' | grep 'fps)' | sed -e 's/^.*b\/s//' | awk '{print $3}'`
# efps=`echo $efps | sed 's/(//'`

psnr=`cat $elog | grep 'PSNR' | awk '{print $5, $6, $7, $8, $9}'`
tmp=`cat $elog | grep mismatch`
if [ "$?" -ne 0 ]; then
  eflag=e_ok
else
  eflag=mismatch
fi

echo "AV1: $(basename $video), profile=$profile bit-depth=$bd bitrate=$bitrate frames=$frames speed=$speed"

taskset -c $core_id ./aomdec /dev/shm/"$bstream" $codec --i420 --noblit --summary 2>&1 &>> $dlog
dtime=`cat $dlog | awk 'NR==1 {NF-=3; print $NF}'`

if [ "$?" -ne 0 ]; then
  dflag=fault
else
  dflag=d_ok
fi

# Note: $8 is the time unit ms or us
dfps=`awk '{print $9}' < $dlog`
dfps=`echo $dfps | sed 's/(//'`

vp9enctime=337444
ev1v9time=`echo "($etime / $vp9enctime)" | bc -l`
ev1v9time=${ev1v9time:0:5}

vp9dectime=555720
dv1v9time=`echo "($dtime / $vp9dectime)" | bc -l`
dv1v9time=${dv1v9time:0:5}

bs_dir=/run/shm
cd $bs_dir
wc=`cat $bstream | wc -c`

echo -e '\t'"Enc fps    Dec fps    PSNR"'\t\t\t\t'"Enc status   Dec status   dup(%)         eup(%)"
echo -e '\t'$etime"    "$dfps"     "$psnr'\t'$eflag"              "$dflag"     "$dpercent"    "$epercent
printf "\n"

# Output a html log file for email
echo "<table style=\"width:100%\">" >> $log_path/$html_log_file
echo "  <tr>" >> $log_path/$html_log_file
echo "    <th colspan=\"9\">AV1 Speed Weekly: night_720p30.y4m bitrate=$bitrate profile=$profile frames=$frames </th>" >> $log_path/$html_log_file
echo " </tr>" >> $log_path/$html_log_file
echo "  <tr>" >> $log_path/$html_log_file
echo "    <th></th>" >> $log_path/$html_log_file
echo "    <th>Enc Time (ms)</th>" >> $log_path/$html_log_file
echo "    <th>Enc Time (x) VP1 vs VP9</th>" >> $log_path/$html_log_file
echo "    <th>Dec Time (ms)</th>" >> $log_path/$html_log_file
echo "    <th>Dec FPS</th>" >> $log_path/$html_log_file
echo "    <th>Dec Time (x) VP1 vs VP9</th>" >> $log_path/$html_log_file
echo "    <th>Speed</th>" >> $log_path/$html_log_file
echo "    <th>bit-depth</th>" >> $log_path/$html_log_file
echo "    <th>bstream size</th>" >> $log_path/$html_log_file
echo " </tr>" >> $log_path/$html_log_file
echo " <tr>" >> $log_path/$html_log_file
echo "    <td>Encoder</td>" >> $log_path/$html_log_file
echo "    <td>$etime</td>" >> $log_path/$html_log_file
echo "    <td>$ev1v9time</td>" >> $log_path/$html_log_file
echo "    <td></td>" >> $log_path/$html_log_file
echo "    <td></td>" >> $log_path/$html_log_file
echo "    <td></td>" >> $log_path/$html_log_file
echo "    <td>$speed</td>" >> $log_path/$html_log_file
echo "    <td>$bd</td>" >> $log_path/$html_log_file
echo "    <td>$wc</td>" >> $log_path/$html_log_file
echo "  </tr>" >> $log_path/$html_log_file
echo " <tr>" >> $log_path/$html_log_file
echo "    <td>Decoder</td>" >> $log_path/$html_log_file
echo "    <td></td>" >> $log_path/$html_log_file
echo "    <td></td>" >> $log_path/$html_log_file
echo "    <td>$dtime</td>" >> $log_path/$html_log_file
echo "    <td>$dfps</td>" >> $log_path/$html_log_file
echo "    <td>$dv1v9time</td>" >> $log_path/$html_log_file
echo "    <td></td>" >> $log_path/$html_log_file
echo "    <td></td>" >> $log_path/$html_log_file
echo "    <td></td>" >> $log_path/$html_log_file
echo "  </tr>" >> $log_path/$html_log_file
echo "  <tr>" >> $log_path/$html_log_file
echo "    <td colspan=\"9\">cmake ../$libsrc -DCONFIG_UNIT_TESTS=0 -DENABLE_DOCS=0 -DCONFIG_EXPERIMENTAL=1 -DCONFIG_LOWBITDEPTH=1" >> $log_path/$html_log_file
echo " </tr>" >> $log_path/$html_log_file
echo "  <tr>" >> $log_path/$html_log_file
echo "    <td colspan=\"9\">bitstream folder: /cns/yv-d/home/on2-prod/nguyennancy/Weekly/$bstream" >> $log_path/$html_log_file
echo " </tr>" >> $log_path/$html_log_file
echo "  <tr>" >> $log_path/$html_log_file
echo "    <td colspan=\"9\">PSNR $psnr" >> $log_path/$html_log_file
echo " </tr>" >> $log_path/$html_log_file
echo "  <tr>" >> $log_path/$html_log_file
echo "    <td colspan=\"9\">Note: VP9_enc_time=33744, VP9_dec_time=555720 $psnr" >> $log_path/$html_log_file
echo " </tr>" >> $log_path/$html_log_file
echo "</table>" >> $log_path/$html_log_file
echo " <br style=\"width:100%\" style=\"line-height:200%\">" >> $log_path/$html_log_file
#echo " <br style=\"width:100%\" style=\"line-height:150px\">" >> $log_path/$html_log_file
#echo "<p> bitstream folder/cns/yv-d/home/on2-prod/nguyennancy/Weekly/$bstream</p>" >> $log_path/$html_log_file
# Copy bitstream file to cns
#fileutil cp /run/shm/"$bstream" /cns/yv-d/home/on2-prod/nguyennancy/Nightly/.
