require 'net/http'
require 'json'

API_SET_ICON_URL = 'https://slack.com/api/admin.teams.settings.setIcon'

def set_icon(icon_file_or_url)
  raise 'please set SLACK_TOKEN!' unless (token = ENV['SLACK_TOKEN'])
  raise 'please set SLACK_TEAM_ID!' unless (team_id = ENV['SLACK_TEAM_ID'])

  image_url = if icon_file_or_url.to_s.start_with?('http://', 'https://')
                icon_file_or_url
              else
                ENV['SLACK_ICON_URL']
              end
  raise 'please set SLACK_ICON_URL!' unless image_url

  uri = URI(API_SET_ICON_URL)
  req = Net::HTTP::Post.new(uri)
  req['Authorization'] = "Bearer #{token}"
  req['Content-Type'] = 'application/json; charset=utf-8'
  req.body = {
    team_id: team_id,
    image_url: image_url
  }.to_json

  response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
    http.request(req)
  end
  data = JSON.parse(response.body)

  unless response.is_a?(Net::HTTPSuccess)
    raise "Slack HTTP error: #{response.code} #{response.message}: #{data.inspect}"
  end
  raise "Slack API error: #{data.inspect}" unless data['ok']

  true
end