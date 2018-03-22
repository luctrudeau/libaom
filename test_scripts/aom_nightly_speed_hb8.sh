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
  root_dir=~/Dev/av1d
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
test_dir=~/Dev/nightly
script_dir=~/Dev/sandbox/libvpx/scripts

if [ "$bd" == "10" ]; then
. $script_dir/crowd_360p.sh
fi

if [ "$bd" == "8" ]; then
. $script_dir/BasketballDrill_480p.sh
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

elog=av1enc_log_p_$profile.$bd.$speed.txt
dlog=av1dec_log_p_$profile.$bd.$speed.txt
bstream=av1_p_$profile.$speed.$bd.$commit.webm

taskset -c $core_id ./aomenc $verbose -o /dev/shm/"$bstream" $video $codec --limit=$frames --profile=$profile $bitdepth --fps=$fps $tune_content --target-bitrate=$bitrate --skip=0 -p 2 --cpu-used=$speed --lag-in-frames=$laginframes --min-q=0 --max-q=63 --auto-alt-ref=1 --kf-max-dist=150 --kf-min-dist=0 --drop-frame=0 --static-thresh=0 --bias-pct=50 --minsection-pct=0 --maxsection-pct=2000 --arnr-maxframes=7 --arnr-strength=5 --sharpness=0 --undershoot-pct=100 --overshoot-pct=100 --frame-parallel=0 --tile-columns=$col_num --psnr &>> $elog

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
if [ "$?" -ne 0 ]; then
  dflag=fault
else
  dflag=d_ok
fi

# Note: $8 is the time unit ms or us
dfps=`awk '{print $9}' < $dlog`
dfps=`echo $dfps | sed 's/(//'`

dpercent=`echo "($dfps - $pdfps) / $pdfps * 100" | bc -l`
dpercent=${dpercent:0:5}

epercent=`echo "($petime - $etime) / $petime * 100" | bc -l`
epercent=${epercent:0:5}

#x=45425
#vp9=$(($etime /$x))

vp9enct=45188
vp9=`echo "($etime / $vp9enct)" | bc -l`
vp9=${vp9:0:5}

vp9fps=1108.08
dfpsvp9=`echo "($vp9fps / $dfps)" | bc -l`
dfpsvp9=${dfpsvp9:0:5}

bs_dir=/run/shm
cd $bs_dir
bssize=`cat $bstream | wc -c`

echo -e '\t'"Enc fps    Dec fps    PSNR"'\t\t\t\t'"Enc status   Dec status   dup(%)         eup(%)"
echo -e '\t'$etime"    "$dfps"     "$psnr'\t'$eflag"              "$dflag"     "$dpercent"    "$epercent
printf "\n"

# Output a html log file for email
echo "<p style="color:blue"> AV1: $(basename $video), bitrate=$bitrate profile=$profile bit-depth=$bd frames=$frames speed=$speed </p>" >> $log_path/$html_log_file
echo "<table style=\"width:100%\">" >> $log_path/$html_log_file
echo "  <tr bgcolor="#E8F8F8">" >> $log_path/$html_log_file
echo "    <th>Enc Time (ms)</th>" >> $log_path/$html_log_file
echo "    <th>Enc Speedup(%)</th>" >> $log_path/$html_log_file
echo "    <th>Enc Time (x) - VP9 vs AV1</th>" >> $log_path/$html_log_file
echo "    <th>Dec FPS</th>" >> $log_path/$html_log_file
echo "    <th>Dec Speedup(%)</th>" >> $log_path/$html_log_file
echo "    <th>Dec FPS (x) - VP9 vs AV1</th>" >> $log_path/$html_log_file
echo "    <th>PSNR</th>" >> $log_path/$html_log_file
echo "    <th>bstream size (bytes)</th>" >> $log_path/$html_log_file
echo " </tr>" >> $log_path/$html_log_file
echo " <tr>" >> $log_path/$html_log_file
echo "    <td>$etime</td>" >> $log_path/$html_log_file
echo "    <td>$epercent</td>" >> $log_path/$html_log_file
echo "    <td>$vp9</td>" >> $log_path/$html_log_file
echo "    <td>$dfps</td>" >> $log_path/$html_log_file
echo "    <td>$dpercent</td>" >> $log_path/$html_log_file
echo "    <td>$dfpsvp9</td>" >> $log_path/$html_log_file
echo "    <td>$psnr</td>" >> $log_path/$html_log_file
echo "    <td>$bssize</td>" >> $log_path/$html_log_file
echo "  </tr>" >> $log_path/$html_log_file
echo " <tr>" >> $log_path/$html_log_file
echo "    <td colspan=\"8\">bitstream folder: /cns/yv-d/home/on2-prod/nguyennancy/Nightly/$bstream" >> $log_path/$html_log_file
echo "  </tr>" >> $log_path/$html_log_file
echo "    <td colspan=\"8\">Note: VP9 profile=0 bit-depth=8 speed=0 enc_time=45188(ms), dec_time=72197(ms), dec_FPS=1108.08" >> $log_path/$html_log_file
echo "  </tr>" >> $log_path/$html_log_file
echo "</table>" >> $log_path/$html_log_file
echo "</table>" >> $log_path/$html_log_file
echo " <br style=\"width:100%\">" >> $log_path/$html_log_file
# Copy bitstream file to cns
fileutil cp /run/shm/"$bstream" /cns/yv-d/home/on2-prod/nguyennancy/Nightly/.
