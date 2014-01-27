class SkyTrack
  include MongoMapper::Document

  key :source_id, String
  key :no_edit, Boolean

end
