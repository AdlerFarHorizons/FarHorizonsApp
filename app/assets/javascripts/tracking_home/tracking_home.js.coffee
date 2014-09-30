# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#Define layers start
baseLayer = new ol.layer.Tile(source: new ol.source.MapQuest(layer: "sat"))
skyTrackLayer1 = new ol.layer.Tile(source: new ol.source.MapQuest(layer: "sat"))

#Define layers end
#Map add start
map = new ol.Map(
  target: "map"
  layers: [
    baseLayer
    skyTrackLayer1
  ]
  view: new ol.View(
    center: ol.proj.transform([
      37.41
      8.82
    ], "EPSG:4326", "EPSG:3857")
    zoom: 4
  )
)

#Map add end
#Map options start
zoomSlider = (new ol.control.ZoomSlider())
map.addControl zoomSlider

#Map options end
startPoint = new ol.Feature(
  geometry: new ol.geom.Polygon(polyCoords)
  labelPoint: new ol.geom.Point(labelCoords)
  name: "My Polygon"
)

#skyTrackLayer1.drawFeature(yourChangedFeature);