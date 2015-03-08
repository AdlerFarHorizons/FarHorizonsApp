### 
  Baseline is Roxanne Vitorillo's BalloonTracker3.html modified from original
  BalloonTracker2.html during ISGC summer 2013 session.

  Started with scripts extracted from HTML then converted to coffeescript using
  js2coffee.org.
  
  HTML extracted minus head and scripts and placed in
  app/assets/views/tracker/index.html.erb. Javascript includes covered with 
  ruby helper functions at end of that file.
###


###  Parse data from Prediction KML file to show Balloon Burst ###

parseData = (req) ->
  g = new (OpenLayers.Format.KML)(extractStyles: true)
  html = ''
  features = g.read(req.responseText)
  for feat of features
    html += '<ul>'
    html += '<li>' + features[feat].attributes.description + '</li>'
    html += '</ul>'
  document.getElementById('output').innerHTML = html
  return

load = ->
  OpenLayers.loadURL 'data/aPREDICTION.kml', '', null, parseData

  ### must change KML file everytime before flight ###

  return

#window.onbeforeunload = windowClose

### do some preliminary set up ###

oldaltitude = 0
maxaltitude = 0

###this is for the point/packet pop-ups on the maps ###

AutoSizeFramedCloud = OpenLayers.Class(OpenLayers.Popup.FramedCloud, 'autoSize': true)

###this is the default set of options used in many calls ###

options = 
  projection: 'EPSG:900913'
  units: 'm'
  numZoomLevels: 16
  maxResolution: 156543.0339
  maxExtent: new (OpenLayers.Bounds)(-20037508.34, -20037508.34, 20037508.34, 20037508.34)

###and create a projection, size, pixel offset and icons for ###

###plotting  ###

proj = new (OpenLayers.Projection)('EPSG:4326')
size = new (OpenLayers.Size)(8, 8)
offset = new (OpenLayers.Pixel)(-4, -4)
size2 = new (OpenLayers.Size)(12, 12)
offset2 = new (OpenLayers.Pixel)(-6, -6)
iconred = new (OpenLayers.Icon)('assets/markerSmallred.png', size, offset)
iconblue = new (OpenLayers.Icon)('assets/markerSmallblue.png', size, offset)
icongreen = new (OpenLayers.Icon)('assets/markerSmallgreen.png', size, offset)
iconpurple = new (OpenLayers.Icon)('assets/markerSmallpurple.png', size, offset)
iconlandingblue = new (OpenLayers.Icon)('assets/markerLandingblue.png', size2, offset2)
iconlandinggreen = new (OpenLayers.Icon)('assets/markerLandinggreen.png', size2, offset2)
iconlandingpurple = new (OpenLayers.Icon)('assets/markerLandingpurple.png', size2, offset2)
iconBurst = new (OpenLayers.Icon)('sunny.png', size2, offset2)

### end of set up, now start the main work ###

###start up a map ###

map = new (OpenLayers.Map)('map', options)

###and create a couple of layers for the map display ###

streets = new (OpenLayers.Layer.TMS)('Streets', 'assets/maps/streets/',
  'type': 'png'
  'getURL': get_my_url)
aerial = new (OpenLayers.Layer.TMS)('Aerial', 'assets/maps/aerial/',
  'type': 'png'
  'getURL': get_my_url)

###add these layers to the map ###

map.addLayer streets
map.addLayer aerial

###we can set the initial center, add a switcher and a scale ###

cpoint = new (OpenLayers.LonLat)(-87.8, 41.1)
map.setCenter cpoint.transform(proj, map.getProjectionObject()), 11
LaySwitch = new (OpenLayers.Control.LayerSwitcher)
map.addControl LaySwitch
map.addControl new (OpenLayers.Control.ScaleLine)(
  geodesic: true
  maxWidth: 200)

### Add the Layer with the Prediction Track ###

### Strategy.Fixed: requests features once and never requests new data ###

predictionTrack = new (OpenLayers.Layer.Vector)('PREDICTION',
  strategies: [ new (OpenLayers.Strategy.Fixed) ]
  protocol: new (OpenLayers.Protocol.HTTP)(
    url: 'data/aPREDICTION.kml'
    format: new (OpenLayers.Format.KML))
  style:
    strokeColor: 'green'
    strokeWidth: 5
    strokeOpacity: 0.5
  projection: proj)
map.addLayer predictionTrack

###now create marker layers for the three trackers ###

kc9lhw_markerLayer = new (OpenLayers.Layer.Markers)('KC9LHW', projection: proj)
kc9lig_markerLayer = new (OpenLayers.Layer.Markers)('KC9LIG', projection: proj)
wb9sky_markerLayer = new (OpenLayers.Layer.Markers)('WB9SKY', projection: proj)
landingLayer = new (OpenLayers.Layer.Markers)('LANDING', projection: proj)
kc9lhw_markerLayer.id = 'kc9lhw'
kc9lig_markerLayer.id = 'kc9lig'
wb9sky_markerLayer.id = 'wb9sky'

###and add them to the map ###

map.addLayer kc9lhw_markerLayer
map.addLayer kc9lig_markerLayer
map.addLayer wb9sky_markerLayer
map.addLayer landingLayer
onlyCurrent = false

###set up so that the "current point only" click box automatically runs the ###

###routine "setCurrent" ###

document.getElementById('current-toggle').onclick = setCurrent
document.getElementById('predict-toggle').onclick = setPredict
wind_table = 
  x: [
    0
    1
    2
  ]
  y: [
    0
    1
    2
  ]
  w: [
    0
    1
    2
  ]
#readWinds()

### set up the track objects ###

kc9ligTrack = 
  name: 'kc9ligTrack'
  layer: kc9lig_markerLayer
  update: do_trackUpdate
  plot: plot_track2
  parse_trackfile: parse_trackfile
  update_graph: update_graph
  track: []
  series: 0
  e_land: estimate_landing
kc9lhwTrack = 
  name: 'kc9lhwTrack'
  layer: kc9lhw_markerLayer
  update: do_trackUpdate
  plot: plot_track2
  parse_trackfile: parse_trackfile
  update_graph: update_graph
  track: []
  series: 1
  e_land: estimate_landing
wb9skyTrack = 
  name: 'wb9skyTrack'
  layer: wb9sky_markerLayer
  update: do_trackUpdate
  plot: plot_track2
  parse_trackfile: parse_trackfile
  update_graph: update_graph
  track: []
  series: 2
  e_land: estimate_landing
kc9ligTrack.landing = new (OpenLayers.Marker)(new (OpenLayers.LonLat)(0, 0).transform(proj, map.getProjectionObject()), iconlandingpurple.clone())
kc9lhwTrack.landing = new (OpenLayers.Marker)(new (OpenLayers.LonLat)(0, 0).transform(proj, map.getProjectionObject()), iconlandinggreen.clone())
wb9skyTrack.landing = new (OpenLayers.Marker)(new (OpenLayers.LonLat)(0, 0).transform(proj, map.getProjectionObject()), iconlandingblue.clone())
kc9ligTrack.landing.display false
kc9lhwTrack.landing.display false
wb9skyTrack.landing.display false
landingLayer.addMarker kc9ligTrack.landing
landingLayer.addMarker kc9lhwTrack.landing
landingLayer.addMarker wb9skyTrack.landing

### update once and then set on a 5 sec cycle ###

#kc9lhwTrack.update()
#kc9ligTrack.update()
#wb9skyTrack.update()
#setInterval 'kc9ligTrack.update()', 5000
#setInterval 'kc9lhwTrack.update()', 5000
#setInterval 'wb9skyTrack.update()', 5000

###    
Still to do:

Interface work.
  Balloon Dynamics should include van to balloon distance and bearing
  chat sign in and layout improved
  look and feel improved

Van location data and marker

better handling of the creation of map markers. Probably better to recreate each marker each time. May be slower but makes it stateless which is much easier.

Better Landing estimates
  Better handling of wind data

More generally, need to test out hardware/serial routines, work out wireless web serving and van gps aquisition

need to write Processing code to:
  1) select serial port
  2) select callsigns for tracking
  3) clear up chat files
  4) pull wind data
  5) listen to serial port for call sign APRS packets and parse them for callsign.txt files

###

# ---
# generated by js2coffee 2.0.1