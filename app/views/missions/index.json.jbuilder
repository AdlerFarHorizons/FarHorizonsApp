json.array!(@missions) do |mission|
  json.extract! mission, :ident, :start, :target_launch, :actual_launch, :target_end, :actual_end, :chase_vehicles, :platforms
  json.url mission_url(mission, format: :json)
end
