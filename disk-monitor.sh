#!/bin/bash

# This script monitors disk usage and sends an alert if usage exceeds a specified threshold.

THRESHOLD=80
EMAIL="abc@company.com"
LOGFILE="/var/log/disk-monitor.log"

df -hP -x tmpfs -x devtmpfs -x overlay -x squashfs | \
awk 'NR>1 {print $5 " " $6}' | \
while read usage mount
do
     usage=${usage%\%}
        if [ "$usage" -ge "$THRESHOLD" ]; then
            MESSAGE="ALERT: Disk usage on $mount is at $usage% on $(hostname) as of $(date)"
            echo $MESSAGE >> $LOGFILE
            echo $MESSAGE | mail -s "Disk Usage Alert on $(hostname)" $EMAIL
        fi
done