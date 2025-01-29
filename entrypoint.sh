#!/bin/bash

touch /tmp/cron.log && crond && bundle exec whenever --update-crontab && crontab -l && tail -f /tmp/cron.log