require_relative './slack'
require_relative './airtable'
require_relative './browser'

def seed_random
  require 'securerandom'
  srand(SecureRandom.random_number(1_000_000))
end

desc "fetch icon of most projectful ysws"
task :fetch_ysws_icon do
  (Config.get['enable_ysws_fridays'] ? YSWSProgram.top_this_week_with_icon : CommunityLogo.pick_logo).download_icon_and_cdn!
end

desc "fetch random community icon"
task :fetch_community_icon do
  seed_random
  # Poster.log [
  #              "it's about that time...",
  #              "hey, it's that time again!",
  #              "guess what time it is?"
  #            ].sample
  logo = CommunityLogo.pick_logo
  logo.download_icon_and_cdn!
  Poster.logo(logo)
end

desc "change the slack icon to /tmp/icon.png"
task :update_slack do
  seed_random
  ICON_PATH = '/tmp/icon.png'
  # Poster.log [
  #              'okay, here goes nothing...',
  #              'here we go!',
  #              "okay, i'm gonna try to change it..."
  #            ].sample
  begin
    rescale ICON_PATH
    set_icon ICON_PATH
    # Poster.log [
    #              'i think that worked!',
    #              'that oughta do it!',
    #              'done! i think?'
    #            ].sample
  rescue StandardError => e
    Poster.log [
                 'uh oh, we got a problem....',
                 'oh no!',
                 'whoops!'
               ].sample + " hey <@U06QK6AG3RD>: #{e.message}! maybe you need to rotate your xoxd?"
  end
end

desc "set the ysws thing"
task :ysws => [:fetch_ysws_icon, :update_slack]

desc "set a random community logo!"
task :shuffle => [:fetch_community_icon, :update_slack]

task :its_over do
  seed_random
  Poster.log "it's YSWS friday! #{["don't forget to be yourself...", "cya!", "bye..."].sample}"
end

task :were_so_back do
  seed_random
  Poster.log ["now back to your regularly scheduled programming." "we're back!", "we're so back!"].sample
end