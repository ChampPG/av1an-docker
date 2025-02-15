#!/bin/bash

# date=$(date '+%Y-%m-%d')

if ! [ -f /app/media.env ]
then
    echo "[  *] media.env not found, grabbing example."
    wget -O /app/media.env.example "https://raw.githubusercontent.com/46620/Scripts/master/encoding/media.env.example"
    exit 1
else
    source /app/media.env
fi


# Check if CRON is empty or false
if [ -z "$CRON" ] || [ "$CRON" == "false" ]
then
  echo "Change user to non-root"
  # su makepkg
  echo "INFO: CRON setting is empty or false, running av1an encoding once."
  /app/start.sh
else
  # su makepkg
  # Setup cron schedule if CRON is set
  echo "$CRON cd /app/ && /app/start.sh >> /app/av1an.log 2>&1" > /tmp/crontab.tmp
  crontab /tmp/crontab.tmp
  crontab -l
  rm /tmp/crontab.tmp

  # Start cron
  echo "INFO: Starting cron ..."
  touch /var/log/crond.log

  # For Arch, you likely want to use 'cronie' as the cron daemon
  crond -f &

  echo "INFO: cron started"
  tail -F /var/log/crond.log /app/av1an.log 
fi

# /app/start.sh >> /app/av1an.log 2>&1
# tail -F /app/av1an.log