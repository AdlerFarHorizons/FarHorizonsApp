class PredictedTrack
  include MongoMapper::Document

  key :source, String
  key :file_path, String

  belongs_to :platform
  
  timestamps!

end
