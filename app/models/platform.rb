class Platform
  include MongoMapper::Document

  key :description, String
  key :ident, String
  key :beacon_ids, Array
  key :platform_server_id, String
  
  timestamps!
  
  belongs_to :mission
  has_many :sky_tracks
  has_many :predicted_tracks

end
