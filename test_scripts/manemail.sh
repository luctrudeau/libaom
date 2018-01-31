#!/bin/sh
# Note:
# - With any path, be very careful to type the report HTML file name.
# - Use prodcertstatus --show_expiration_time to see when ticket expires.
#

report_html=$1
report_path=/usr/local/google/home/nguyennancy/Dev/log
report_send=$report_path/$report_html
#,vpx-eng

sendgmr --to=nguyennancy --cc=yunqingwang --from=nguyennancy --reply_to=nguyennancy --subject="AV1 Nightly Speed Report" --html_file=$report_send --body_file=$report_send
