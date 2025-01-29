require 'norairrecord'
require 'net/http'

Norairrecord.base_url = ENV['AIRTABLE_ENDPOINT_URL'] if ENV['AIRTABLE_ENDPOINT_URL']
Norairrecord.api_key = ENV['AIRTABLE_PAT']

class YSWSProgram < Norairrecord::Table
  self.base_key = "app3A5kJwYqxMLOgh"
  self.table_name = 'tblrGi9RARJy1A0c5'
  class << self
     def top_this_week_with_icon
      first_where('{Slack Icon}', sort: {"Weighted Projects This Past 7 Days (rolling)" => "desc"})
    end
  end
  def icon_url
    fields.dig('Slack Icon', 0, 'url')
  end
  def download_icon!
    puts "downloading icon..."
    File.write("/tmp/ysws_icon.png", Net::HTTP.get(URI.parse(icon_url)))
    puts "ok!"
  end
end

