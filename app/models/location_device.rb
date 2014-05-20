class LocationDevice
  include MongoMapper::Document

  key :make, String
  key :model, String
  key :serial_no, String
  key :driver, String
  key :driver_pid, Integer
  key :port, String
  key :persistent, Boolean, :default => true
    
  has_one :point #this point is persistent. It's fields are updated on each fix
  
  timestamps!
  
  after_create :initialize_point

  
  private

  def initialize_point
    self.point = Point.create( :source_id => self.id.to_s )
    self.point.save
    self.save
  end

end
