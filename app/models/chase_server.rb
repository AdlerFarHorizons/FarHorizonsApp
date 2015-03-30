class ChaseServer
  include MongoMapper::Document

  key :hostname, String
  key :make, String
  key :model, String
  key :serial_no, String
  key :sw_version, String
  key :location_device_id, String
  key :beacon_receiver_ids, Array
  key :router_id, String
  key :persistent, Boolean, :default => true
  
  timestamps!
  
  # Methods for pseudo-associations
  
  def location_device
    LocationDevice.find( location_device_id )
  end
  
  def beacon_receivers
    result = []
    beacon_receiver_ids.each do |x| 
      result << BeaconReceiver.find( x )
    end
    result
  end
  
  def router
    Router.find( router_id )
  end

end
