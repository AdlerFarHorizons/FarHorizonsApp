class SkyTrack
  include MongoMapper::Document

  key :id_source, String # Beacon id
  key :ident, String
  key :no_edit, Boolean, :default => true
  
  belongs_to :platform
  
  has_many :points
  
  timestamps!

  def add_point point
    points << point
    self
  end

end
