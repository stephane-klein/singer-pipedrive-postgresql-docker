#!/bin/bash

gomplate -f /tap-pipedrive-config.json.tmpl -o /tap-pipedrive-config.json
gomplate -f /target_postgres_config.json.tmpl -o /target_postgres_config.json
gomplate -f /crontab.tmpl -o /etc/crontab

declare -p | grep -Ev 'BASHOPTS|BASH_VERSINFO|EUID|PPID|SHELLOPTS|UID' > /container.env

crontab /etc/crontab
cron -n & tail -f /var/log/cron.log