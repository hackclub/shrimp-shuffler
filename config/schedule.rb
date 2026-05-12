set :output, "/tmp/cron.log"

# every 30 minutes on friday
every "0,30 * * * 5" do
  rake "ysws"
end

# every 30 minutes on not-friday
every "0,30 * * * 0-4,6" do
  rake "shuffle"
end

every :friday, at: '12:00 AM' do
  rake "its_over"
end

every :saturday, at: '12:00 AM' do
  rake "were_so_back"
end