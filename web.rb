require 'sinatra'
require 'active_support'
require 'active_support/cache'
require 'active_support/core_ext/object'

require_relative './airtable'

configure do
  mime_type :plaintext, 'text/plain'
  set :cache, ActiveSupport::Cache::MemoryStore.new
end


def current_shuffle_key
  now = Time.now
  shuffle_time = if now.min < 30
                   Time.new(now.year, now.month, now.day, now.hour, 0, 0)
                 else
                   Time.new(now.year, now.month, now.day, now.hour, 30, 0)
                 end
  shuffle_time.to_i
end

def fetch_logos(single: false)
  max_records = single ? 1 : nil
  cache_key = "logos_#{current_shuffle_key}_#{single}"
  
  cached = settings.cache.read(cache_key)
  if cached
    @all_community_logos = cached[:community]
    @all_ysws_logos = cached[:ysws]
    @current_logo = cached[:current]
    return
  end
  
  @all_community_logos = CommunityLogo.where(
    'AND({Active}, {Slack Icon})',
    sort: { "Last Shown" => "asc" },
    max_records:
  )

  @all_ysws_logos = YSWSProgram.where(
    '{Slack Icon}',
    sort: { "Weighted Projects This Past 7 Days (rolling)" => "desc" },
    max_records:
  )

  @current_logo = if Date.today.friday?
                    @all_ysws_logos.first
                  else
                    if Config.get['override']
                      CommunityLogo.find Config.get['override'].first
                    else
                      @all_community_logos.last
                    end
                  end
  
  settings.cache.write(cache_key, {
    community: @all_community_logos,
    ysws: @all_ysws_logos,
    current: @current_logo
  })
end

get '/' do
  fetch_logos
  
  now = Time.now
  next_shuffle = if now.min < 30
                   Time.new(now.year, now.month, now.day, now.hour, 30, 0)
                 else
                   now + (60 - now.min) * 60 - now.sec
                 end
  cache_control :public, max_age: (next_shuffle - now).to_i
  
  erb :index
end

get "/api/current" do
  fetch_logos single: true
  content_type :plaintext
  @current_logo.cdn_url || @current_logo.icon_url
end