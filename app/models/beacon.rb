class Beacon
  include MongoMapper::Document

  key :make, String
  key :model, String
  key :serial_no, String
  key :call_sign, String
  key :persistent, Boolean, :default => true
  
  timestamps!

  has_one :point #this point is persistent. It's fields are updated on each fix

  after_create :initialize_point
  
  private

  def initialize_point
    self.point = Point.create( :source_sn => self.serial_no )
    self.point.save
    self.save
  end

end
