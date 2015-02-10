json.array!(@points) do |point|
  json.extract! point, :time, :x, :y, :z, :vg, :vx, :vy, :vz, :id_source
  json.url point_url(point, format: :json)
end
