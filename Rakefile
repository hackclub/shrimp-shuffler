desc "fetch icon of most projectful ysws"
task :fetch_ysws_icon do
  require_relative './airtable'
  (Config.get['enable_ysws_fridays'] ? YSWSProgram.top_this_week_with_icon : CommunityLogo.pick_logo).download_icon!
end

desc "fetch icon of most projectful ysws"
task :fetch_community_icon do
  require_relative './airtable'
  CommunityLogo.pick_logo.download_icon!
end

desc "change the slack icon to /tmp/icon.png"
task :update_slack do
  require_relative './browser'
  set_icon('/tmp/icon.png')
end

desc "set the ysws thing"
task :ysws => [:fetch_ysws_icon, :update_slack]

desc "set a random community logo!"
task :shuffle => [:fetch_community_icon, :update_slack]
