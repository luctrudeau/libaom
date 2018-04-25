#!/bin/sh
set -x

log_path=~/Devtest/log
html_log_file=aomencwk.html
cd $log_path
rm $html_log_file

elog_dir=~/Devtest/weekly
cd $elog_dir
rm -r -f *

av1_code=~/Devtest/av1w

cd $av1_code/aom
commit=`git log --pretty=%h -1`

script_path=~/Devtest/sandbox/aom/test_scripts

$script_path/gen_html_header.sh >> $log_path/$html_log_file

echo "<p>" >> $log_path/$html_log_file
$script_path/sync_codebase_weekly.sh >> $log_path/$html_log_file 2>&1
echo "</p>" >> $log_path/$html_log_file

echo "<p>" >> $log_path/$html_log_file
$script_path/aom_cmake_weekly.sh $av1_code >> $log_path/$html_log_file 2>&1
echo "</p>" >> $log_path/$html_log_file

$script_path/aom_weekly_speed_hb8.sh
$script_path/aom_weekly_speed_hb10.sh


# Send an email to coworkers
users=nguyennancy
host_name=`hostname`
sender=nguyennancy
#cc_list="--cc=yunqingwang"
#cc_list="--cc=yunqingwang,vpx-eng"

$script_path/gen_html_footer.sh >> $log_path/$html_log_file

sendgmr --to=$users $cc_list --subject="AV1 WEEKLY SPEED REPORT" --from=$sender --reply_to=$sender --html_file=/usr/local/google/home/nguyennancy/Devtest/log/$html_log_file --body_file=/usr/local/google/home/nguyennancy/Devtest/log/$html_log_file

