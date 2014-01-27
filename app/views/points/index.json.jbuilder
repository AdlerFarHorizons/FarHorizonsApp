json.array!(@points) do |point|
  json.extract! point, :id, :time, :x, :y, :z, :vg, :vx, :vy, :vz, :source_id, :host_id, :no_edit
  json.url point_url(point, format: :json)
end
