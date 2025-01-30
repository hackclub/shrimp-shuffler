require 'mechanize'

def set_icon(icon_file)
  raise "please set SLACK_XOXD!" unless (xoxd = ENV['SLACK_XOXD'])
  raise "please set SLACK_SLUG!" unless (slug = ENV['SLACK_SLUG'])

  agent = Mechanize.new

  agent.user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.1.1 Safari/605.1.15"

  agent.cookie_jar << Mechanize::Cookie.new(:domain => ".slack.com", :name => 'd', :value => xoxd, :path => '/', :expires => (Date.today + 1).to_s)

  page = agent.get("https://#{slug}.slack.com/customize/icon")

  form = page.forms.find { |f| f.action == "/customize/icon" }
  raise StandardError, "couldn't find form 1!" unless form

  upload = form.file_upload('img')
  raise StandardError, "couldn't find upload!?" unless upload
  upload.file_name = icon_file

  page = form.submit

  form = page.forms.first
  raise StandardError, "couldn't find crop form!" unless form

  # TODO: maybe parse image for size? but who gaf
  form.field('cropbox').value = "0,0,1024"
  form.submit
end