json.array!(@points) do |point|
  json.extract! point, :time, :x, :y, :z, :vg, :vx, :vy, :vz, :source_id, :host_id
  json.url point_url(point, format: :json)
end
