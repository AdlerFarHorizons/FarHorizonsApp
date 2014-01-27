class ChaseServer
  include MongoMapper::Document

  key :hostname, String
  key :make, String
  key :model, String
  key :serial_no, String
  key :sw_version, String
  key :location_device_id, String
  key :beacon_transmitter_id, String
  key :beacon_receiver_ids, Array
  key :router_id, String
  key :persistent, Boolean

end
