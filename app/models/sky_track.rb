class SkyTrack
  include MongoMapper::Document

  key :source_sn, String # Beacon serial_no
  key :no_edit, Boolean, :default => true
  
  belongs_to :platform
  
  has_many :points
  
  timestamps!

  def add_point point
    points << point
    self
  end

end
