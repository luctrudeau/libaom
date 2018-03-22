#!/bin/sh
#set -x

script_path=~/Dev/sandbox/libvpx/scripts

av1_code=~/Dev/av1w
log_path=~/Dev/log

date_str=`date -d today +%b_%d_%Y`

html_log_file=aomencweekly_$date_str.html

#s0_log_file=av1_s0_$date_str.txt
s1_log_file=av1w_s1_$date_str.txt
# hbd(10bit)
#hbd_s0_log_file=av1_hbd_s0_$date_str.txt
hbd_s1_log_file=av1w_hbd_s1_$date_str.txt

test_dir=~/Dev/weekly
rm $test_dir/*

$script_path/gen_html_header.sh > $log_path/$html_log_file

echo "<p>" >> $log_path/$html_log_file
$script_path/sync_codebase.sh $av1_code/aom >> $log_path/$html_log_file 2>&1
echo "</p>" >> $log_path/$html_log_file

echo "<p>" >> $log_path/$html_log_file
$script_path/aom_weekly_config.sh $av1_code/aom >> $log_path/$html_log_file 2>&1
echo "</p>" >> $log_path/$html_log_file

echo "<p>" >> $log_path/$html_log_file
$script_path/aom_conf_build_weekly.sh $av1_code
#$script_path/aom_conf_build.sh $av1_code >> $log_path/$html_log_file 2>&1
echo "</p>" >> $log_path/$html_log_file

dfps=`cat $log_path/$s1_log_file | grep e_ok | awk '{print $2}' | awk 'NR==1 {print $1}'`
etime=`cat $log_path/$s1_log_file | grep e_ok | awk '{print $1}' | awk 'NR==1 {print $1}'`
speed=1
bd=8
$script_path/aom_weekly_speed_hb8.sh $av1_code $dfps $etime $speed $bd $html_log_file >> $log_path/$s1_log_file>&1

dfps=`cat $log_path/$hbd_s1_log_file | grep e_ok | awk '{print $2}' | awk 'NR==1 {print $1}'`
etime=`cat $log_path/$hbd_s1_log_file | grep e_ok | awk '{print $1}' | awk 'NR==1 {print $1}'`
speed=1
bd=10
$script_path/aom_weekly_speed_hb10.sh $av1_code $dfps $etime $speed $bd $html_log_file >> $log_path/$hbd_s1_log_file>&1

# Send an email to coworkers
users=nguyennancy
host_name=`hostname`
sender=nguyennancy
#cc_list="--cc=yunqingwang,vpx-eng"

$script_path/gen_html_footer.sh >> $log_path/$html_log_file

sendgmr --to=$users $cc_list --subject="AV1 Speed Weekly" --from=$sender --reply_to=$sender --html_file=/usr/local/google/home/nguyennancy/Dev/log/$html_log_file --body_file=/usr/local/google/home/nguyennancy/Dev/log/$html_log_file
