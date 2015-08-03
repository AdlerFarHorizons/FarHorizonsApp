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
  
  # Methods for pseudo-associations
  
  def platform_server
    PlatformServer.find( platform_server_id )
  end
  
  def beacons
    Beacon.all.select {|b| beacon_ids.include?( b.id.to_s )}
  end

end
