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
  
  key :source_sn, String # LocationDevice or Beacon serial_no
  key :handle, String # APRS call sign, beacon ID or vehicle handle
  key :no_edit, Boolean, :default => true

  timestamps!
  
end
