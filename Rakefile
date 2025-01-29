desc "fetch icon of most projectful ysws"
task :fetch_icon do
  require_relative './airtable'
  YSWSProgram.top_this_week_with_icon.download_icon!
end

desc "change the slack icon to /tmp/ysws_icon.png"
task :update_slack do
  require_relative './browser'
  set_icon('/tmp/ysws_icon.png')
end

desc "do the thing!"
task :shuffle => [:fetch_icon, :update_slack]
