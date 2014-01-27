class LocationDevice
  include MongoMapper::Document

  key :make, String
  key :model, String
  key :serial_no, String
  key :driver, String
  key :port, String
  key :persistent, Boolean, :default => true
    
  has_one :point
  
  timestamps!

end
