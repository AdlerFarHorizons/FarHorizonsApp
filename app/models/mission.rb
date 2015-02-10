class Mission
  include MongoMapper::Document

  key :description, String
  key :ident, String
  key :start, Time
  key :target_launch, Time
  key :actual_launch, Time
  key :target_end, Time
  key :actual_end, Time

  timestamps!
  
  has_many :chase_vehicles
  
  has_many :platforms

end
