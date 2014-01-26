
config = YAML.load_file(Rails.root + 'config' + 'mongo.yml')
logger = Rails.env.production? ? nil : nil #Rails.logger
MongoMapper.setup(config, Rails.env, { :logger => logger })