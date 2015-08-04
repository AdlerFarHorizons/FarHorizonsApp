require 'pusher'

config = YAML.load_file(Rails.root + 'config' + 'pusher.yml')[Rails.env]

Pusher.app_id = config['app_id']
Pusher.key    = config['key']
Pusher.secret = config['secret']
Pusher.host = Socket.gethostname()
Pusher.port = 4567
#Pusher.url = 
#  "https://#{Pusher.key}:#{Pusher.secret}@api.pusherapp.com/apps/#{Pusher.app_id}"
Pusher.logger = Rails.logger

