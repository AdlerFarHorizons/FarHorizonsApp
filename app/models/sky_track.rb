class SkyTrack
  include MongoMapper::Document

  key :source_id, String
  key :no_edit, Boolean, :default => true
  
  belongs_to :platform
  
  has_many :points
  
  timestamps!

end
