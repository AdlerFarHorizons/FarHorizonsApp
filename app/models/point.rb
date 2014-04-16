##
# Represents a single Position/Velocity/Time point

class Point
  include MongoMapper::Document

  key :time, Time, :default => Time.at(0) # Timestamp
  key :x, Float, :default => 0.0  
  key :y, Float, :default => 0.0
  key :z, Float, :default => 0.0
  key :vg, Float, :default => 0.0  
  key :vx, Float
  key :vy, Float
  key :vz, Float
  key :source_id, String # LocationDevice or Beacon
  key :host_id, String # ChaseVehicle or Platform  
  key :no_edit, Boolean, :default => true

  timestamps!
  
end
