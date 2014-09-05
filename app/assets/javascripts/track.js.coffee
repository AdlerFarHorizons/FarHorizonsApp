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
pointRef = new OpenLayers.Geometry.Point(-111.04, 45.68)
point1 = pointRef.clone() # LN - used for projection
pointFeature1 = new OpenLayers.Feature.Vector(point1.transform(src, dst), null, style_blue)
point2 = new OpenLayers.Geometry.Point(-105.04, 49.68)
pointFeature2 = new OpenLayers.Feature.Vector(point2.transform(src, dst), null, style_green)
point3 = new OpenLayers.Geometry.Point(-105.04, 49.68)
pointFeature3 = new OpenLayers.Feature.Vector(point3.transform(src, dst), null, style_mark)

# create a line feature from a list of points
pointList = []
tmpPoint = pointRef.clone()
p = 0

while p < 15
  tmpPoint = new OpenLayers.Geometry.Point(tmpPoint.x + Math.random(1), tmpPoint.y + Math.random(1))
  temp = tmpPoint.clone()
  pointList.push temp.transform(src, dst)
  ++p
lineFeature = new OpenLayers.Feature.Vector(new OpenLayers.Geometry.LineString(pointList), null, style_green)

# create a polygon feature from a linear ring of points
pointList = []
p = 0

while p < 6
  a = p * (2 * Math.PI) / 7
  r = Math.random(1) + 1
  newPoint = new OpenLayers.Geometry.Point(pointRef.x + (r * Math.cos(a)), pointRef.y + (r * Math.sin(a)))
  pointList.push newPoint.transform(src, dst)
  ++p
pointList.push pointList[0]
linearRing = new OpenLayers.Geometry.LinearRing(pointList)
polygonFeature = new OpenLayers.Feature.Vector(new OpenLayers.Geometry.Polygon([linearRing]))
map.addLayer vectorLayer
map.setCenter new OpenLayers.LonLat(point1.x, point1.y), 5
vectorLayer.addFeatures [
  pointFeature1
  pointFeature3
  pointFeature2
  lineFeature
  polygonFeature
]
