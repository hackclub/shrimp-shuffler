require 'puppeteer-ruby'

def set_icon(icon_file)
  raise "please set SLACK_XOXD!" unless (xoxd = ENV['SLACK_XOXD'])
  raise "please set SLACK_SLUG!" unless (slug = ENV['SLACK_SLUG'])
  Puppeteer.launch(args: ['--no-sandbox', '--disable-gpu']) do |browser|
    page = browser.new_page
    page.set_cookie(
      name: 'd',
      value: xoxd,
      domain: "#{slug}.slack.com",
      expires: -1,
      )
    puts "going to page..."
    page.goto("https://#{slug}.slack.com/customize/icon")
    puts "waiting for upload to appear..."
    upload = page.wait_for_selector('#image_file_upload')
    puts "uploading #{icon_file}..."
    upload.upload_file(icon_file)
    puts "clicking upload button..."
    page.click('#image_upload_button')
    puts "waiting for crop button..."
    crop = page.wait_for_selector('#cropbtn')
    page.wait_for_timeout(1500)
    puts "clicking crop button..."
    crop.click
    puts "waiting for nav..."
    page.wait_for_navigation
    puts "should be done!"
  end
end

