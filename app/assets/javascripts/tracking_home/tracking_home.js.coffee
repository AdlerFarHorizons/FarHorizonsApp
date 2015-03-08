map = undefined
satLayer = undefined
startPoint = undefined
streetLayer = undefined
zoomSlider = undefined
featureList1 = new ol.Feature(
  geometry: new ol.geom.LineString([
    [
      -81.62
      41.88
    ]
    -[
      80
      40
    ]
  ])
  name: "testLine1"
)
satLayer = new ol.layer.Tile(source: new ol.source.MapQuest(layer: "sat"))
streetLayer = new ol.layer.Tile(source: new ol.source.MapQuest(layer: "osm"))

#projection:new ol.proj.EPSG4326(),
featuresLayer1 = new ol.layer.Vector(source: new ol.source.Vector(features: featureList1)) #this array is defined above
map = new ol.Map(
  interactions: ol.interaction.defaults().extend([new ol.interaction.Select(style: new ol.style.Style(image: new ol.style.Circle(
    radius: 5
    fill: new ol.style.Fill(color: "#FF0000")
  )))])
  target: "map"
  layers: [
    satLayer
    streetLayer
  ]
  view: new ol.View(
    center: ol.proj.transform([
      37.41
      8.82
    ], "EPSG:4326", "EPSG:3857")
    zoom: 4
  )
)
map.addLayer satLayer #remember to capitalize the L's!
map.addLayer streetLayer
map.addLayer featuresLayer1

#Styles:
blueStyle = [new ol.style.Style(
  fill: new ol.style.Fill(color: "blue")
  stroke: new ol.style.Stroke(
    color: "blue"
    width: 3
  )
)]
greenStyle = [new ol.style.Style(
  fill: new ol.style.Fill(color: "#00FF00")
  stroke: new ol.style.Stroke(
    color: "#00FF00"
    width: 3
  )
)]
redStyle = [new ol.style.Style(
  fill: new ol.style.Fill(color: "#FF0000")
  stroke: new ol.style.Stroke(
    color: "#FF0000"
    width: 3
  )
)]
markStyle = [new ol.style.Style({})]

#ol3 API docs has only has a title, but nothing in the body for styles
#pass for now

#there are actually functions to get and trace location of the mobile device (probably with GPS enabled) on map with setTracking(), and stuff like getAltitude( 
#The following zoom slider actually works!
zoomSlider = new ol.control.ZoomSlider()
map.addControl zoomSlider

#startPoint = new ol.Feature({
#  geometry: new ol.geom.Polygon(polyCoords),
#  labelPoint: new ol.geom.Point(labelCoords),
#  name: "My Polygon"
#});
