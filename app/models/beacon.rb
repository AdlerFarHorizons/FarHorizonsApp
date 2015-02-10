class Beacon
  include MongoMapper::Document

  key :make, String
  key :model, String
  key :serial_no, String
  key :ident, String # Call sign for APRS tracker
  key :persistent, Boolean, :default => true
  
  timestamps!

end
