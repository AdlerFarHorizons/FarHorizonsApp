class Platform
  include MongoMapper::Document

  key :description, String
  key :identifier, String
  key :beacon_ids, Array
  key :platform_server_id, String

end
