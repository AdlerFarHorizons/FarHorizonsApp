class Point
  include MongoMapper::Document

  key :time, Time
  key :x, Float
  key :y, Float
  key :z, Float
  key :vg, Float
  key :vx, Float
  key :vy, Float
  key :vz, Float
  key :source_id, String
  key :host_id, String
  key :no_edit, Boolean

end
