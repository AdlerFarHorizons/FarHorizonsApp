class Router
  include MongoMapper::Document

  key :make, String
  key :model, String
  key :serial_no, String
  key :address, String
  key :ssid, String
  key :persistent, Boolean, :default => true
  
  timestamps!

end
