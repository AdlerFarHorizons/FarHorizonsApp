class Beacon
  include MongoMapper::Document

  key :make, String
  key :model, String
  key :serial_no, String
  key :call_sign, String
  key :persistent, Boolean, :default => true
  
  timestamps!

  has_one :point

end
