#!/bin/bash
set -euo pipefail

bundle exec whenever --update-crontab
exec cron -f
