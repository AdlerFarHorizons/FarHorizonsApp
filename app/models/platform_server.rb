class PlatformServer
  include MongoMapper::Document

  key :hostname, String
  key :make, String
  key :model, String
  key :serial_no, String
  key :sw_version, String
  key :persistent, Boolean, :default => true
  
  timestamps!

end
