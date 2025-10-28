require 'norairrecord'
require 'net/http'
require 'json'

Norairrecord.base_url = ENV['AIRTABLE_ENDPOINT_URL'] if ENV['AIRTABLE_ENDPOINT_URL']
Norairrecord.api_key = ENV['AIRTABLE_PAT']

class Logo < Norairrecord::Table
  def icon_url = fields.dig('Slack Icon', 0, 'url')
  def cdn_url = fields['Icon – CDN Link']
  def name = fields['Name']

  def creator = fields['Icon – Creator']


  def download_icon_and_cdn!
    puts "downloading icon..."
    File.write("/tmp/icon.png", Net::HTTP.get(URI.parse(icon_url)))
    puts "ok!"
    hash = file_hash
    return if hash == fields['Icon – Last Hash']
    puts "updating cdn link..."
    patch(
      'Icon – Last Hash' => hash,
      'Icon – CDN Link' => upload_to_cdn(icon_url)
    )
  end
end

class YSWSProgram < Logo
  self.base_key = "app3A5kJwYqxMLOgh"
  self.table_name = 'tblrGi9RARJy1A0c5'

  def self.top_this_week_with_icon = first_where(
      '{Slack Icon}',
      sort: { "Weighted Projects This Past 7 Days (rolling)" => "desc" }
     )
end

class CommunityLogo < Logo
  self.base_key = "appOOH0x03NEHw8Rt"
  self.table_name = 'tbl1blRyjt0AUVBvJ'

  def self.pick_logo
    if Config.get['override']
      logo = find Config.get['override'].first
      puts "overridden to #{logo['Name']}."
      return logo
    end
    puts "sampling logos..."
    candidates = records(filter: 'AND({Active}, {Slack Icon})', sort: { "Last Shown" => "asc" }, max_records: Config.get['randomize_count'])
    logo = candidates.sample
    raise "what?!" unless logo
    logo.patch('Last Shown' => Time.now)
    puts "picked #{logo['Name']}!"
    logo
  end
end

class Config < Norairrecord::Table
  self.base_key = "appOOH0x03NEHw8Rt"
  self.table_name = "tblN8zhtIgHBQLHBm"

  class << self
    def fetch = find "recgEG7YTjRcKI1jq?"
    def get = @config ||= fetch
    def refresh = @config = fetch
  end
end

def file_hash = Digest::SHA256.file('/tmp/icon.png').hexdigest

def upload_to_cdn(url)
  resp = Net::HTTP.post(
    URI.parse("https://cdn.hackclub.com/api/v3/new"),
    [url].to_json,
    {
      'content-type' => 'application/json',
      'authorization' => 'Bearer beans'
    }
  ).body
  JSON.parse(resp).dig("files", 0, "deployedUrl")
end