# Ensure unique serial numbers for persistent objects and
# unique identifier for mission
task :set_db_indices => :environment do
  Mission.ensure_index [[ :identifier, 1 ]]
  LocationDevice.ensure_index [[ :serial_no, 1 ]], :unique => true
  Beacon.ensure_index [[ :serial_no, 1]], :unique => true
  BeaconTransmitter.ensure_index [[ :serial_no, 1 ]], :unique => true
  BeaconReceiver.ensure_index [[ :serial_no, 1 ]], :unique => true
  ChaseServer.ensure_index [[ :serial_no, 1 ]], :unique => true
  Router.ensure_index [[ :serial_no, 1 ]], :unique => true
  PlatformServer.ensure_index [[ :serial_no, 1 ]], :unique => true
end

task :seed_database => :environment do
  
end