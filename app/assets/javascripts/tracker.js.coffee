### 
  Baseline is Roxanne Vitorillo's BalloonTracker3.html modified from original
  BalloonTracker2.html during ISGC summer 2013 session.

  Started with scripts extracted from HTML then converted to coffeescript using
  js2coffee.org.
  
  HTML extracted minus head and scripts and placed in
  app/assets/views/tracker/index.html.erb. Javascript includes covered with 
  ruby helper functions at end of that file.
###

hostname = window.location.hostname
port = window.location.port

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
  OpenLayers.loadURL '/data/aPREDICTION.kml', '', null, parseData

  ### must change KML file everytime before flight ###

  return

#window.onbeforeunload = windowClose

### do some preliminary set up ###

oldaltitude = 0
maxaltitude = 0

###this is for the point/packet pop-ups on the maps ###

AutoSizeFramedCloud = OpenLayers.Class(OpenLayers.Popup.FramedCloud, 'autoSize': true)

###this is the default set of options used in many calls ###
OpenLayers.ImgPath = "/assets/OpenLayers/img/"
options = 
  projection: 'EPSG:900913'
  units: 'm'
  numZoomLevels: 17
  maxResolution: 156543.0339
  maxExtent: new (OpenLayers.Bounds)(-20037508.34, -20037508.34, 20037508.34, 20037508.34)
  controls: [new OpenLayers.Control.PanZoomBar,
             new OpenLayers.Control.Navigation({dragPanOptions: {enableKinetic: true}})]

###and create a projection, size, pixel offset and icons for ###

###plotting  ###

proj = new (OpenLayers.Projection)('EPSG:4326') # x/y => lat/lon
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

# NOTE: Path to stuff in app/assets/images is 'assets/<path beneath app/assets>
mapPort = $('#data').data( 'mapPort' )
streets = new (OpenLayers.Layer.TMS)('Streets', 'http://' + hostname + ':' + mapPort.toString() + '/streets/', #'assets/map.tiles/streets/',
  'type': 'png'
  'getURL': get_my_url)
aerial = new (OpenLayers.Layer.TMS)('Aerial', 'http://' + hostname + ':' + mapPort.toString() + '/aerial/', #'assets/map.tiles/aerial/',
  'type': 'png'
  'getURL': get_my_url)

###add these layers to the map ###

map.addLayer streets
map.addLayer aerial

dst = map.getProjectionObject()  # EPSG:900913 (a.k.a. EPSG:3857) x/y => meters

###we can set the initial center, add a switcher and a scale ###

start_lat = 41.1000322 # degrees
start_lon = -87.9167100 # degrees
cpoint = new (OpenLayers.LonLat)( start_lon, start_lat )
map.setCenter cpoint.transform(proj, dst), 11
LaySwitch = new (OpenLayers.Control.LayerSwitcher)
map.addControl LaySwitch
map.addControl new (OpenLayers.Control.ScaleLine)(
  geodesic: true
  maxWidth: 200)

### Add the Layer with the Prediction Track ###

### Strategy.Fixed: requests features once and never requests new data ###

# NOTE: Path to stuff in puplic folder is <path beneath public>
predictionTrack = new (OpenLayers.Layer.Vector)('Prediction',
  strategies: [ new (OpenLayers.Strategy.Fixed) ]
  protocol: new (OpenLayers.Protocol.HTTP)(
    url: '/data/aPREDICTION.kml'
    format: new (OpenLayers.Format.KML))
  style:
    strokeColor: 'green'
    strokeWidth: 5
    strokeOpacity: 0.5
  projection: proj)
map.addLayer predictionTrack

# Marker layers removed


# ---- Here's where the vector layer example code hack starts

# allow testing of specific renderers via "?renderer=Canvas", etc
renderer = OpenLayers.Util.getParameters(window.location.href).renderer
renderer = (if (renderer) then [renderer] else OpenLayers.Layer.Vector::renderers)

#
#    * Layer style
#    

# we want opaque external graphics and non-opaque internal graphics
layer_style = OpenLayers.Util.extend({}, OpenLayers.Feature.Vector.style["default"])
layer_style.fillOpacity = 0.5
layer_style.graphicOpacity = 1

#
#    * Blue style
#    
style_blue = OpenLayers.Util.extend({}, layer_style)
style_blue.strokeColor = "blue"
style_blue.fillColor = "blue"
style_blue.graphicName = "star"
style_blue.pointRadius = 5
style_blue.strokeWidth = 2
style_blue.rotation = 45
style_blue.strokeLinecap = "butt"

style_point_red = OpenLayers.Util.extend({}, layer_style)
style_point_red.strokeColor = "red"
style_point_red.fillColor = "red"
style_point_red.graphicName = "circle"
style_point_red.pointRadius = 3
style_point_red.strokeWidth = 1
style_point_red.rotation = 45
style_point_red.strokeLinecap = "butt"

#
#    * Green style
#    
style_green =
  strokeColor: "#00FF00"
  strokeWidth: 3
  strokeDashstyle: "solid"
  pointRadius: 6
  pointerEvents: "visiblePainted"
  title: "this is a green line"

#
#    * Mark style
#    
style_mark = OpenLayers.Util.extend({}, OpenLayers.Feature.Vector.style["default"])
style_mark.graphicOpacity = 1
style_mark.graphicWidth = 16
style_mark.graphicHeight = 16
style_mark.graphicXOffset = -style_mark.graphicWidth / 2 # default is -(style_mark.graphicWidth/2);
style_mark.graphicYOffset = -style_mark.graphicHeight
# LN - Path to vendor assets is 'assets/<path beneath javascripts>
style_mark.externalGraphic = "/assets/OpenLayers/img/marker.png"
style_mark.title = "this is a test tooltip"

#
#    * Balloon style
#    
style_balloon = OpenLayers.Util.extend({}, OpenLayers.Feature.Vector.style["default"])
style_balloon.graphicOpacity = 1
style_balloon.graphicWidth = 16
style_balloon.graphicHeight = 16
style_balloon.graphicXOffset = -style_balloon.graphicWidth / 2 # default is -(style_balloon.graphicWidth/2);
style_balloon.graphicYOffset = -style_balloon.graphicHeight
style_balloon.externalGraphic = "/assets/balloon.png"
# title only works in Firefox and Internet Explorer
style_balloon.title = "this is a test tooltip"

#
#    * van style
#    
style_van = OpenLayers.Util.extend({}, OpenLayers.Feature.Vector.style["default"])
style_van.graphicOpacity = 1
style_van.graphicWidth = 16
style_van.graphicHeight = 16
style_van.graphicXOffset = -style_van.graphicWidth / 2 # default is -(style_van.graphicWidth/2);
style_van.graphicYOffset = -style_van.graphicHeight / 2
# LN - Path to vendor assets is '/assets/<path beneath javascripts>
style_van.externalGraphic = "/assets/van.png"
# title only works in Firefox and Internet Explorer
style_van.title = "this is a test tooltip"

platformLayer = new OpenLayers.Layer.Vector("Platform",
  style: layer_style
  renderers: renderer
)
vehicleLayer = new OpenLayers.Layer.Vector("Vehicle",
  style: layer_style
  renderers: renderer
)

map.addLayer platformLayer
map.addLayer vehicleLayer

thisVehicleLastTime = null
thisVehiclePoint = new OpenLayers.Geometry.Point( null, null )
thisVehicleLocation = null
urlVehicleLoc = '/chase_vehicle_location/'
thisVehicleId = $('#data').data( 'thisVehicle' ).id
locDev = $('#data').data( 'locDev' )

updateVehicleLocation = ( vehicleId ) ->
  $.getJSON urlVehicleLoc + vehicleId, (data) ->
    if data and data['time'] isnt thisVehicleLastTime
      vehicleLayer.destroyFeatures( [ thisVehicleLocation ] ) if thisVehicleLocation
      tmpPoint = new OpenLayers.Geometry.Point( data['lon'], data['lat'] )
      thisVehiclePoint = tmpPoint.clone().transform( proj, dst )
      thisVehicleLocation = new OpenLayers.Feature.Vector( 
        thisVehiclePoint, null, style_van )
      vehicleLayer.addFeatures( [ thisVehicleLocation ] )
      thisVehicleLastTime = data['time']

platforms = $('#data').data('platforms')
platformIds = ( x.id for x in platforms )
urlPlatformTracks = '/platform_tracks/'
platformTracks = ( [] for x in platformIds )
platformTrackMultiPoints = ( [] for x in platformIds )
platformTrackLines = ( [] for x in platformIds )
platformTrackTimes = ( "Jan 28 1986" for x in platformIds )
platformLocations = ( [] for x in platformIds )
beaconRcvrs = $('#data').data('beaconRcvrs')

updatePlatformTracks = ( index ) ->

  $.getJSON urlPlatformTracks + platformIds[index], after_time: platformTrackTimes[index], (data) ->
    if data
      for track in data
        newTrackFlg = true
        unless track is null
          for temp, num in platformTracks[index]
            if temp.ident is track.ident
              # append new points to reference array
              newTrackFlg = false            
              temp.points.push( track.points )
              # append new points to feature point array
              lastPoint = null
              for point in track.points
                tmpPoint = new OpenLayers.Geometry.Point( point['lon'], point['lat'] )
                platformTrackMultiPoints[index][num].addPoint( tmpPoint.clone().transform( proj, dst ) )
                platformTrackLines[index][num].addPoint( tmpPoint.clone().transform( proj, dst ) )
                lastPoint = tmpPoint
              if lastPoint
                platformLayer.destroyFeatures( [ platformLocations[index][num] ] )
                platformLocations[index][num] = new OpenLayers.Feature.Vector(
                  tmpPoint.clone().transform( proj, dst ), null, style_balloon )
                platformLayer.addFeatures( [ platformLocations[index][num] ] )

              temp.last_time = track.last_time
              platformTrackTimes[index] = temp.last_time if temp.last_time > platformTrackTimes[index]
        
        if newTrackFlg and track isnt null
        
          platformTracks[index].push track
          platformTrackMultiPoints[index].push new OpenLayers.Geometry.MultiPoint([])
          platformTrackLines[index].push new OpenLayers.Geometry.LineString(null)
          platformTrackTimes[index] = track.last_time
          platformLocations[index].push null
          trackIndex = platformTracks[index].length - 1
          lastPoint = null
          
          for point, num in track.points
          
            tmpPoint = new OpenLayers.Geometry.Point( point['lon'], point['lat'] )
            platformTrackMultiPoints[index][trackIndex].addPoint( 
              tmpPoint.clone().transform( proj, dst ) )
            platformTrackLines[index][trackIndex].addPoint( 
              tmpPoint.clone().transform( proj, dst ) )
            lastPoint = tmpPoint
            
          platformLayer.addFeatures( [ new OpenLayers.Feature.Vector(
              platformTrackLines[index][trackIndex], null, style_green ) ] )
          platformLayer.addFeatures( [ new OpenLayers.Feature.Vector(
              platformTrackMultiPoints[index][trackIndex], null, style_point_red ) ] )

          if lastPoint
          
            platformLocations[index][trackIndex] = new OpenLayers.Feature.Vector(
              tmpPoint.clone().transform( proj, dst ), null, style_balloon )
            platformLayer.addFeatures( [ platformLocations[index][trackIndex] ] )

      platformLayer.redraw()
                    
isSim = false
for rcvr in beaconRcvrs
  isSim = true if rcvr.driver[-3...] is 'sim'
isSim = true if locDev.driver[-3...] is 'sim'

### update once and then set on a 5 sec cycle ###
updateVehicleLocation( thisVehicleId )
updatePlatformTracks( 0 ) 
count = 0
timerId =
  setInterval => # 'Fat' arrow stransfers 'scope' (or whatever it's called in
                 # js) to the inner function.
    updateVehicleLocation(thisVehicleId)
    updatePlatformTracks( 0 )
    #clearInterval( timerId ) if count++ is 2
  , 10000

$('#control #locSimStart').click ->
  if isSim
    vehicleLayer.destroyFeatures()
    thisVehicleLastTime = null
    thisVehiclePoint = new OpenLayers.Geometry.Point( null, null )
    thisVehicleLocation = null

  speedup = $("#simSpeed input[type='radio']:checked").val()

  url = 'http://' + hostname + ':' + port + '/location_devices/start/' + locDev.id + '/' + speedup
  $.post url, (data) ->
    $('#control #locDriver').html(data)

$('#control #locSimEnd').click ->
  url = 'http://' + hostname + ':' + port + '/location_devices/stop/' + locDev.id
  $.post url, (data) ->
    $('#control #locDriver').html(data)

$('#control #beaconSimStart').click ->
  if isSim
    platformLayer.destroyFeatures()
    platformTracks = ( [] for x in platformIds )
    platformTrackMultiPoints = ( [] for x in platformIds )
    platformTrackLines = ( [] for x in platformIds )
    platformTrackTimes = ( "Jan 28 1986" for x in platformIds )
    platformLocations = ( [] for x in platformIds )

  speedup = $("#simSpeed input[type='radio']:checked").val()
  
  for rcvr in beaconRcvrs  
    url = 'http://' + hostname + ':' + port + '/beacon_receivers/start/' + rcvr.id + '/' + speedup
    $.post url, (data) ->
      $('#control #beaconDriver').html(data)
      #console.log 'Sim Start'

$('#control #beaconSimEnd').click ->
  for rcvr in beaconRcvrs
    url = 'http://' + hostname + ':' + port + '/beacon_receivers/stop/' + rcvr.id
    #console.log 'Sim End'
    $.post url, (data) ->
      $('#control #beaconDriver').html(data)

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