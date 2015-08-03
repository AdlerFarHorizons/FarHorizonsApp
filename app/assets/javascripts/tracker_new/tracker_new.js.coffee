hostname = window.location.hostname
port = window.location.port
image_port = $('#data').data( 'imagePort' )
image_root = "http://" + hostname + ":" + image_port + "/"
start_lat = 41.1000322 # degrees
start_lon = -87.9167100 # degrees
start_zoom = 11
max_zoom = 16

# Enable pusher logging - don't include this in production
#Pusher.log = (message) ->
#  if window.console and window.console.log
#    window.console.log message
#  return

pusher = new Pusher('c33f8eaa482b900bae75', 
  wsHost: hostname
  wsPort: '8080'
  wssPort: '8080'
  enabledTransports: [
    'ws'
    'flash'
  ]
)

strokeRed = new ol.style.Stroke( color: 'red', width: 2 )
strokeBlue = new ol.style.Stroke(color: 'blue', width: 1, lineDash: [5,20] )
strokeCyan = new ol.style.Stroke( color: 'cyan', width: 2 )
fillRed = new ol.style.Fill(color: 'red')
fillBlue = new ol.style.Fill(color: 'blue')

balloonStyle = new ol.style.Style
  image: new ol.style.Icon
    anchor: [ 0.5, 1 ]
    anchorXUnits: 'fraction'
    anchorYUnits: 'fraction'
    opacity: 1.00
    scale: 1.25
    src: image_root + 'balloon.png'

crossStyle = new ol.style.Style
  image: new ol.style.RegularShape
    stroke: strokeRed
    points: 4
    radius: 10
    radius2: 0
    angle: 0  

deltaLineStyle = new ol.style.Style
  stroke: strokeBlue

trackLineStyle = new ol.style.Style
  stroke: strokeCyan

# Server data
platforms = $('#data').data('platforms')
platformIds = ( x.id for x in platforms )
platformIdents = ( x.ident for x in platforms )
platformBeacons = $('#data').data('beacons')
urlPlatformTracks = '/platform_tracks/'
urlVehicleLoc = '/chase_vehicle_location/'
thisVehicleId = $('#data').data( 'thisVehicle' ).id
thisVehicleIdent = $('#data').data( 'thisVehicle' ).ident
locDev = $('#data').data( 'locDev' )

# platformTracks is an array of hashes, one for each platform,
# where key:values are track idents:point array associated with that platform.
# platformTrack lines is similarly structured where the values
# are ol3 LineString objects
platformTracks = []
platformTrackLines = []

vectorSource = new ol.source.Vector( features: [] )

for x in platformIds
  platformTracks.push( {} )
  platformTrackLines.push( {} )
for x, index in platformTracks
  for y in platformBeacons[index]
    x[y.ident] = []
    platformTrackLines[index][y.ident] = 
      new ol.geom.LineString( [] ) 
    vectorSource.addFeature( 
      new ol.Feature(
        ident: y.ident,
        geometry: platformTrackLines[index][y.ident]
        style: trackLineStyle
      )
    )

beaconRcvrs = $('#data').data('beaconRcvrs')

# Vector layer objects
point1 = null
point2 = null
deltaLine = null
payloadFeature = null
chaseFeature = null
deltaFeature = null

featuresLayer = new ol.layer.Vector( source: vectorSource )

for platformId, index in platformIds
  pIndex = index # 'index' doesn't pass into function properly
  $.getJSON urlPlatformTracks + platformId, (data) ->
    console.log "get tracks: data:", data
    if data
      for track, num in data
        ident = track.ident
        
        temp = track.points[ track.points.length - 1 ]
        point1 = new ol.geom.Point(
          ol.proj.transform( [ temp.lon, temp.lat ], "EPSG:4326", "EPSG:3857")
          )
        payloadFeature = new ol.Feature
          geometry: point1
          name: 'Platform'
        payloadFeature.setStyle balloonStyle
        vectorSource.addFeature( payloadFeature )
        
        platformTracks[pIndex][ident] = track
        for point in track.points
          platformTrackLines[pIndex][ident].appendCoordinate(
            ol.proj.transform([ point.lon, point.lat ], "EPSG:4326", "EPSG:3857")
          )
          temp = point
        console.log "platformTrackLines:", platformTrackLines
        console.log "vectorSource features:", vectorSource.getFeatures()
        
satLayer = new ol.layer.Tile(
  source: new ol.source.XYZ(
    url: 'http://' + hostname + ':' + image_port + '/tiles/aerial/{z}/{x}/{y}.png'
    layer: "sat"
    maxZoom: max_zoom
  )
  visible: false
)

streetLayer = new ol.layer.Tile( 
  source: new ol.source.XYZ(
    url: 'http://' + hostname + ':' + image_port + '/tiles/streets/{z}/{x}/{y}.png'
    layer: "street"
    maxZoom: max_zoom
  )
  visible: true
)

map = new ol.Map(
  interactions: ol.interaction.defaults().extend([new ol.interaction.Select(style: new ol.style.Style(image: new ol.style.Circle(
    radius: 5
    fill: new ol.style.Fill(color: "#FF0000")
  )))])
  target: "map"
  layers: [streetLayer, satLayer]
  view: new ol.View(
    center: ol.proj.transform([ start_lon, start_lat ], "EPSG:4326", "EPSG:3857")
    zoom: start_zoom
  )
)
map.addLayer featuresLayer

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

#ol3 API docs has only has a title, but nothing in the body for styles
#pass for now

#there are actually functions to get and trace location of the mobile device (probably with GPS enabled) on map with setTracking(), and stuff like getAltitude( 
#The following zoom slider actually works!
zoomSlider = new ol.control.ZoomSlider()
map.addControl zoomSlider
#-----------------

locChannel = pusher.subscribe( 'ChaseVehicle_' + thisVehicleIdent )
locChannel.bind 'new_point', (data) ->
  point = [ data.message.lon, data.message.lat ]
  if not point2
    point2 = new ol.geom.Point( ol.proj.transform( point, "EPSG:4326", "EPSG:3857") )
  else
    point2.setCoordinates( ol.proj.transform( point, "EPSG:4326", "EPSG:3857") )
  if not chaseFeature
    chaseFeature = new ol.Feature
      geometry: point2
      name: 'Chase Vehicle'
    chaseFeature.setStyle crossStyle
    vectorSource.addFeature( chaseFeature )
  if not deltaFeature
    if point1
      deltaLine = new ol.geom.LineString(
        [ point2.getCoordinates(), point1.getCoordinates() ]
      )
      deltaFeature = new ol.Feature( geometry: deltaLine )
      deltaFeature.setStyle deltaLineStyle
      vectorSource.addFeature( deltaFeature )
  else
    deltaLine.setCoordinates(
      [ point2.getCoordinates(), point1.getCoordinates() ]
    )
  return

console.log "platformTrackLines:", platformTrackLines
platformChannels = []
for id, index in platformIds
  pIndex = index
  platformChannels.push(
    pusher.subscribe( 'Platform_' + id ).bind 'new_point', (data) ->      
      point = [ data.message.lon, data.message.lat ]
      ident = data.message.ident
      if not point1
        point1 = new ol.geom.Point( ol.proj.transform( point, "EPSG:4326", "EPSG:3857") )
      else
        point1.setCoordinates( ol.proj.transform( point, "EPSG:4326", "EPSG:3857") )
      if not payloadFeature
        payloadFeature = new ol.Feature
          geometry: point1
          name: 'Platform'
        payloadFeature.setStyle balloonStyle
        vectorSource.addFeature( payloadFeature )
      if not deltaFeature
        if point2
          deltaLine = new ol.geom.LineString(
            [ point2.getCoordinates(), point1.getCoordinates() ]
          )
          deltaFeature = new ol.Feature( geometry: deltaLine )
          deltaFeature.setStyle deltaLineStyle
          vectorSource.addFeature( deltaFeature )
      platformTrackLines[pIndex][ident].appendCoordinate( 
        ol.proj.transform( point, "EPSG:4326", "EPSG:3857") )

      return
  )
                  
isSim = false
for rcvr in beaconRcvrs
  isSim = true if rcvr.driver[-3...] is 'sim'
isSim = true if locDev.driver[-3...] is 'sim'

$('#control #locSimStart').click ->
  if isSim
    #vehicleLayer.destroyFeatures()
    thisVehicleLastTime = null
    #thisVehiclePoint = new OpenLayers.Geometry.Point( null, null )
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
    platformLocations = ( [] for x in platformIds )

  speedup = $("#simSpeed input[type='radio']:checked").val()
  
  for rcvr in beaconRcvrs  
    url = 'http://' + hostname + ':' + port + '/beacon_receivers/start/' + rcvr.id + '/' + speedup
    $.post url, (data) ->
      $('#control #beaconDriver').html(data)

$('#control #beaconSimEnd').click ->
  for rcvr in beaconRcvrs
    url = 'http://' + hostname + ':' + port + '/beacon_receivers/stop/' + rcvr.id
    $.post url, (data) ->
      $('#control #beaconDriver').html(data)

