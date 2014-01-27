class Beacon
  include MongoMapper::Document

  key :make, String
  key :model, String
  key :serial_no, String
  key :call_sign, String
  key :persistent, Boolean

end
