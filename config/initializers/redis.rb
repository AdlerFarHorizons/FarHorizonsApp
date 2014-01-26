redis_config = YAML.load_file('config/redis.yml')
redis_config = redis_config[Rails.env].inject({}){|r,a| r[a[0].to_sym]=a[1]; r}
RedisConnection = Redis.new( redis_config  )
