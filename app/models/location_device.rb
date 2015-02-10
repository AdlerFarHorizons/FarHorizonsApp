class LocationDevice
  include MongoMapper::Document

  key :make, String
  key :model, String
  key :serial_no, String
  key :driver, String
  key :driver_pid, Integer
  key :port, String
  key :persistent, Boolean, :default => true
      
  timestamps!
  
end
