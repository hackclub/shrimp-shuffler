require 'slack-notifier'
module Poster
  class << self
    def hook
      @hook ||=  ENV['SLACK_HOOK'] ? Slack::Notifier.new(ENV['SLACK_HOOK']) : nil
    end
    def log(msg)
      puts msg
      hook&.ping(msg)
    end
    def blocks(blocks)
      hook&.post(blocks:)
    end

    def logo(l)
      blocks([
          {
            "type": "section",
            "text": {
              "type": "mrkdwn",
              "text": [
                "BEGINlet's go with LOGO!",
                "BEGINLOGO, i choose you!",
                "BEGINit's LOGO time",
                "BEGINwhat if we changed the slack logo to LOGO?",
                'i love that scene where slack went "it\'s LOGO-in\' time" and LOGOed all over the place'
              ].sample.gsub('BEGIN', [
                "okay, ",
                "alright, ",
                "hmmmm......",
                '',
                '',
                '',
                '',
                '',
                ''
              ].sample).gsub('LOGO', l.name)
            },
            "accessory": {
              "type": "image",
              "image_url": l.icon_url,
              "alt_text": l.name
            }
          }
        ])
    end
  end
end