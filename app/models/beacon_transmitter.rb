class BeaconTransmitter
  include MongoMapper::Document

  key :make, String
  key :model, String
  key :serial_no, String
  key :driver, String
  key :port, String
  key :call_sign, String
  key :persistent, Boolean, :default => true
  
  timestamps!

end
