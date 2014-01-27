class Mission
  include MongoMapper::Document

  key :description, String
  key :identifier, String
  key :start, Time
  key :target_launch, Time
  key :actual_launch, Time
  key :target_end, Time
  key :actual_end, Time

end
