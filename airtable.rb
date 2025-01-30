require 'norairrecord'
require 'net/http'

Norairrecord.base_url = ENV['AIRTABLE_ENDPOINT_URL'] if ENV['AIRTABLE_ENDPOINT_URL']
Norairrecord.api_key = ENV['AIRTABLE_PAT']

class Logo < Norairrecord::Table
  def icon_url
    fields.dig('Slack Icon', 0, 'url')
  end
  def download_icon!
    puts "downloading icon..."
    File.write("/tmp/icon.png", Net::HTTP.get(URI.parse(icon_url)))
    puts "ok!"
  end
end

class YSWSProgram < Logo
  self.base_key = "app3A5kJwYqxMLOgh"
  self.table_name = 'tblrGi9RARJy1A0c5'
  class << self
     def top_this_week_with_icon
      first_where('{Slack Icon}', sort: {"Weighted Projects This Past 7 Days (rolling)" => "desc"})
    end
  end
end

class CommunityLogo < Logo
  N = 15

  self.base_key = "appOOH0x03NEHw8Rt"
  self.table_name = 'tbl1blRyjt0AUVBvJ'

  class << self
    def pick_logo
      puts "sampling logos..."
      candidates = records(filter: 'AND({Active}, {Slack Icon})', sort: {"Last Shown" => "asc"}, max_records: N)
      logo = candidates.sample
      raise "what?!" unless logo
      logo.patch('Last Shown' => Time.now)
      puts "picked #{logo['Name']}!"
      logo
    end
  end
end
