class SkyTrack
  include MongoMapper::Document

  key :id_source, String # Beacon id
  key :ident, String
  key :no_edit, Boolean, :default => true
  
  before_destroy :clean_up
  
  belongs_to :platform
  
  has_many :points
  
  timestamps!

  def add_point point
    points << point
    self
  end

  private
  
  def clean_up
    self.points.each { |p| p.destroy }
  end
  
end
