set :output, "/tmp/cron.log"

every 30.minutes do
  rake "shuffle"
end