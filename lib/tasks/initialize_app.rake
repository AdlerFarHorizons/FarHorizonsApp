
task :reset_app => :environment do
  unless Rails.env.production?
    Rake::Task['reset_db_indices'].execute
    Rake::Task['reset_db'].execute
  else
    puts "Can't use this task in production environment"
  end
end

# Ensure unique serial numbers for persistent objects and
# unique identifier for mission
task :reset_db_indices => :environment do
  unless Rails.env.production?
    # Clear out all indices first
    Dir.foreach("app/models") do |x|
      if x.end_with?(".rb")
        model = x.split('.rb')[0]
        klass = eval(model.titleize.split.join)
        puts "Dropping indices for:klass:#{klass.to_s.pluralize}"
        klass.drop_indexes()
      end
    end

    # Re-set indexes
    puts "Resetting indices..."
    Mission.ensure_index [[ :identifier, 1 ]], :unique => true
    LocationDevice.ensure_index [[ :serial_no, 1 ]], :unique => true
    Beacon.ensure_index [[ :serial_no, 1]], :unique => true
    BeaconReceiver.ensure_index [[ :serial_no, 1 ]], :unique => true
    ChaseServer.ensure_index [[ :serial_no, 1 ]], :unique => true
    Router.ensure_index [[ :serial_no, 1 ]], :unique => true
    PlatformServer.ensure_index [[ :serial_no, 1 ]], :unique => true
    puts "Done."
  else
    puts "Can't use this task in production environment"
  end
end

task :reset_db => :environment do
  # Clears and re-sets collections represented in app/models only
  unless Rails.env.production? 
  # Clear database first
    Dir.foreach("app/models") do |x|
      if x.end_with?('.rb')
        model = x.split(".rb")[0]
        puts "deleting #{model.titleize.split.join.pluralize}"
        klass = eval(model.titleize.split.join)
        klass.delete_all  
      end
    end

    # Load objects from json dump file
    file = File.open("db/dev_db_init_jsons",'r')
    data = file.readlines
    file.close
    data.each do |line|
      klass = eval(line.split("=>")[0])
      json_data = line[line.index(">")+1..line.length-2] # excludes newline at end
      puts "creating object:#{klass}"
      klass.create( JSON.parse(json_data) )
    end
  else
    puts "Can't use this task in production environment"
  end
end  

task :reset_redis => :environment do
  unless Rails.env.production?
    RedisConnection.flushdb()
    RedisConnection.set( 'beacon_filter',
                         ['WB9SKY-11', 'KC9LIG-11', 'KC9LHW-11'])
  else
    puts "Can't use this task in production environment"
  end
end