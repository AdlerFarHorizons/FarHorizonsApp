task :dump_db_to_jsons  => :environment do
  unless Rails.env.production?
    file = File.open( "db/dev_db_init_jsons", 'w')
    Dir.foreach("app/models") do |x|
      if x.end_with?(".rb")
        model = x.split(".rb")[0]
        puts "storing #{model.titleize.split.join.pluralize}"
        klass = eval(model.titleize.split.join) 
        klass.all.each do |object|
          file.write( "#{object.class.to_s}=>#{object.to_json}\n" )
        end
      end
    end
    file.close  
  else
    puts "Can't use this task in production environment. Use mongod utilities"
  end
end