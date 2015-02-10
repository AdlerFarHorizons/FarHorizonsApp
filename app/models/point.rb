##
# Represents a single Position/Velocity/Time point

class Point
  include MongoMapper::Document

  key :time, Time, :default => Time.at(0) # Timestamp

  # ECEF
  key :x, Float, :default => 0.0  
  key :y, Float, :default => 0.0
  key :z, Float, :default => 0.0
  key :vx, Float, :default => 0.0
  key :vy, Float, :default => 0.0
  key :vz, Float, :default => 0.0
  
  # Surface-based
  key :lat, Float, :default => 0.0
  key :lon, Float, :default => 0.0
  key :alt, Float, :default => 0.0
  key :vg, Float, :default => 0.0 
  key :heading, Float, :default => 0.0
  
  key :id_source, String # LocationDevice or Beacon id
  key :ident, String # beacon ident or vehicle ident 
  key :no_edit, Boolean, :default => true
  
  # Double belongs_to is lame but a result of point being a common belongs_to
  # for sky_track and ground_track. They both need to have their has_many points
  # association reciprocated. In practice one of these will return nil.
  belongs_to :ground_track
  belongs_to :sky_track

  timestamps!
  
end
