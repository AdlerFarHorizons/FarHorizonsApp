class ChaseVehicle
  include MongoMapper::Document

  key :description, String
  key :ident, String
  key :chase_server_id, String
  
  belongs_to :mission
  
  has_one :ground_track
  
  timestamps!

end
