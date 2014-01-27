class PredictedTrack
  include MongoMapper::Document

  key :source, String
  key :file_path, String

end
