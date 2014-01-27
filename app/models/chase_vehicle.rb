class ChaseVehicle
  include MongoMapper::Document

  key :description, String
  key :identifier, String
  key :chase_server_id, String

end
