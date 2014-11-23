# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# LN - Adapted from
# https://github.com/openlayers/openlayers/blob/master/examples/vector-features.html
# to use OSM instead of WMS.
# This is the coffeescript version converted using js2coffee at js2coffee.org:
# I pasted the javascript version (now named file track.js.bak) into the
# the javascript window on the left and then copied the code from the 
# coffeescript window on the right and pasted that into the track.js.coffee
# file.

# To use the javascript file, remove the '.bak' from it and add '.bak' to this
# filename. 

map = new OpenLayers.Map("navFrame") # arg = div id

# LN - Using OSM instead of WMS
layer = new OpenLayers.Layer.OSM("OpenLayers OSM")
#layer = new OpenLayers.Layer.WMS( "OpenLayers WMS",
#                  "http://vmap0.tiles.osgeo.org/wms/vmap0", {layers: 'basic'} )

map.addLayer layer

# allow testing of specific renderers via "?renderer=Canvas", etc
renderer = OpenLayers.Util.getParameters(window.location.href).renderer
renderer = (if (renderer) then [renderer] else OpenLayers.Layer.Vector::renderers)

#
#    * Layer style
#    

# we want opaque external graphics and non-opaque internal graphics
layer_style = OpenLayers.Util.extend({}, OpenLayers.Feature.Vector.style["default"])
layer_style.fillOpacity = 0.2
layer_style.graphicOpacity = 1

#
#    * Blue style
#    
style_blue = OpenLayers.Util.extend({}, layer_style)
style_blue.strokeColor = "blue"
style_blue.fillColor = "blue"
style_blue.graphicName = "star"
style_blue.pointRadius = 10
style_blue.strokeWidth = 3
style_blue.rotation = 45
style_blue.strokeLinecap = "butt"

#
#    * Green style
#    
style_green =
  strokeColor: "#00FF00"
  strokeWidth: 3
  strokeDashstyle: "dashdot"
  pointRadius: 6
  pointerEvents: "visiblePainted"
  title: "this is a green line"

#
#    * Red style
#    
style_red =
  strokeColor: "#FF0000"
  strokeWidth: 3
  strokeDashstyle: "dashdot"
  pointRadius: 6
  pointerEvents: "visiblePainted"
  title: "this is a red line"

#
#    * Mark style
#    
style_mark = OpenLayers.Util.extend({}, OpenLayers.Feature.Vector.style["default"])

# each of the three lines below means the same, if only one of
# them is active: the image will have a size of 24px, and the
# aspect ratio will be kept
# style_mark.pointRadius = 12;
# style_mark.graphicHeight = 24; 
# style_mark.graphicWidth = 24;

# if graphicWidth and graphicHeight are both set, the aspect ratio
# of the image will be ignored
style_mark.graphicWidth = 24
style_mark.graphicHeight = 20
style_mark.graphicXOffset = 10 # default is -(style_mark.graphicWidth/2);
style_mark.graphicYOffset = -style_mark.graphicHeight

# LN - Path to vendor assets 
style_mark.externalGraphic = "/assets/img/marker.png"

# title only works in Firefox and Internet Explorer
style_mark.title = "this is a test tooltip"
vectorLayer = new OpenLayers.Layer.Vector("Simple Geometry",
  style: layer_style
  renderers: renderer
)

# LN - OSM uses different projection. Make transformation objects
# see:
# http://docs.openlayers.org/library/spherical_mercator.html#sphericalmercator-and-epsg-aliases
src = new OpenLayers.Projection("EPSG:4326") # x/y => lat/lon degrees
dst = map.getProjectionObject() # EPSG:900913 (a.k.a. EPSG:3857) x/y => meters

# create a point feature

# LN - Need to separately maintain Lat Lon point variables to use for the math 
# when calculating the polygon and line features. Important to clone, not equate
# them into another variable for transforming to the OSM projection since the 
# transformation is done "in place" and will modify the original variable as 
# well if you used an equate to initialize it.
pointRef = new OpenLayers.Geometry.Point(-87.6278, 41.8819 ) # Chicago
#point1 = pointRef.clone() # LN - used for projection
#pointFeature1 = new OpenLayers.Feature.Vector(pointRef.clone().transform(src, dst), null, style_blue)
#point2 = new OpenLayers.Geometry.Point(-105.04, 49.68)
#pointFeature2 = new OpenLayers.Feature.Vector(point2.transform(src, dst), null, style_green)
#point3 = new OpenLayers.Geometry.Point(-105.04, 49.68)
#pointFeature3 = new OpenLayers.Feature.Vector(point3.transform(src, dst), null, style_mark)

# create a line feature from a list of points
pointList = []
tmpPoint = pointRef.clone()
temp = tmpPoint.clone()
pointList.push temp.transform( src, dst )
p = 1

while p < 15
  tmpPoint = new OpenLayers.Geometry.Point(tmpPoint.x + Math.random(1), tmpPoint.y + Math.random(1))
  pointList.push tmpPoint.clone().transform(src, dst)
  ++p
lineFeature = new OpenLayers.Feature.Vector(new OpenLayers.Geometry.LineString(pointList), null, style_red)

## create a polygon feature from a linear ring of points
#pointList = []
#p = 0
#
#while p < 6
#  a = p * (2 * Math.PI) / 7
#  r = Math.random(1) + 1
#  newPoint = new OpenLayers.Geometry.Point(pointRef.x + (r * Math.cos(a)), pointRef.y + (r * Math.sin(a)))
#  pointList.push newPoint.transform(src, dst)
#  ++p
#pointList.push pointList[0]
#linearRing = new OpenLayers.Geometry.LinearRing(pointList)
#polygonFeature = new OpenLayers.Feature.Vector(new OpenLayers.Geometry.Polygon([linearRing]))
map.addLayer vectorLayer
tmpPoint = pointRef.clone().transform( src, dst )
map.setCenter new OpenLayers.LonLat(tmpPoint.x, tmpPoint.y), 5
vectorLayer.addFeatures [
  #pointFeature1
  #pointFeature3
  #pointFeature2
  lineFeature
  #polygonFeature
]

# LN - How to add a point to lineFeature "in-place" and update the layer after
# the feature has already been added to the layer.

# Create a new point. Here I'm just using a clone of current value of tmpPoint, 
# which happens to be the center of the map and is already transformed properly
newPoint = tmpPoint.clone()

# To find out exactly how to address the line feature points array I had to use
# console.log since the API for OpenLayers.Geometry.LineString says it's a 
# property called "points", but that doesn't exist. It's actually addressed as
# "components" as you can see when you look at what we set as the "geometry" 
# argument (the first argument) when we invoked the constructor to create the
# lineFeature:
#console.log lineFeature.geometry
lineFeature.geometry.components.push newPoint

# In spite of all the noise on the interweb about refreshing a vector layer
# involving adding a refresh strategy to the vector layer and using the
# the refresh() method therein, I tried the following obvious approach based on
# the redraw method that all Layer subclasses inherit from Layer:
vectorLayer.redraw()
# NOTE: There are functions listed in Layer.Vector that can refresh even
# individual feature on the layer, but I didn't explore them.

# GET'ing from a server route in JSON format using jQuery.
# NOTE: the variable name '$' standard shorthand for 'jQuery'
url = '/ground_tracks'
$.getJSON url, (data) ->
  # 'data' contains all ground tracks in the data base, so it is an array
  #console.log data  
  # Picking the last point from the first track returned:
  lastpoint = data[0].points[data[0].points.length - 1]
  
  # Displaying the point coordinates in a specific span within a specific div
  # in the HTML using jQuery:
  $("#point #coords").html( lastpoint.x + ", " + lastpoint.y + ", " + lastpoint.z )
  