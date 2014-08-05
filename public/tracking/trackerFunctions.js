// function to return the URL of the tiles
function get_my_url(bounds) {
    var res = this.map.getResolution();
    var x = Math.round ((bounds.left - this.maxExtent.left) / (res * this.tileSize.w));
    var y = Math.round ((this.maxExtent.top - bounds.top) / (res * this.tileSize.h));
    var z = this.map.getZoom();
    
    var path = z + "/" + x + "/" + y + "." + this.type;
    var url = this.url;
    if (url instanceof Array) {
        url = this.selectUrl(path, url);
    }
    return url + path;    
}

function read_trackfile() {

    // start by reading the track file on the server
    var txtFile = new XMLHttpRequest();
    txtFile.open("POST", "./"+this.layer.id+"track.txt", true);

    // define a function that executes on server response to the HttpRequest
    txtFile.onreadystatechange = function() {
	// Make sure the document is ready to parse and the file is found.
	if ((txtFile.readyState === 4) && (txtFile.status === 200)) {  
	    // Seperate each line into an array
	    var lines = txtFile.responseText.split("\n"); 
	    for (i=0;(lines.length)>i;i++){
		// split up the lines into lat, long, altitude, etc.
		var line_elements = lines[i].split(",");		    
		this.track[i]=line_elements;

	    }
	}
    }
    txtFile.send(null);
}



function update_plots() {

    // evantually it would be best to have the plot file read here and data placed into 
    // data structure and have only the
    // plotting in plot_track

    kc9lhwTrack.read_trackfile();
    kc9ligTrack.read_trackfile();
    wb9skyTrack.read_trackfile();

    kc9lhwTrack.plot();
    kc9ligTrack.plot();
    wb9skyTrack.plot();
    /*
    plot_track(kc9lig_markerLayer);                                 
    plot_track(kc9lhw_markerLayer);                 
    plot_track(wb9sky_markerLayer);                               
    */
    // eventually we will want the graph updates here

    // also we will want to put all the track/landing estimation in here

}

// this function does all of the work in plotting the tracks
function plot_track2() {
    
    N_old=this.layer.markers.length;
    //    printf(N_old);
    // only continue if there is new data
    if ((this.track.length)>N_old) {
	var i=0;
	// do only the new lines
	for (i=N_old;i<this.track.length;i++){
	    
	    // add a marker onto the map
	    addMarker(this.layer,this.track[i]);

	}
	
	// set the visibility of the points to reflect the "current point only" 
	// toggle 
	setCurrent();
	
	// update the onscreen current balloon location text
	document.getElementById('BalloonStats').innerHTML="Current Dynamics: "+line_elements[4]+" ft, "+line_elements[3]+" mph, "+line_elements[2]+"&deg; heading";
	
    }
}

/*
	    // update sidebar graphs 
	    if (markerLayer.id=="wb9sky") {chart2.series[0].addPoint([eval(D),eval(line_elements[4])],false,false);}
	    if (markerLayer.id=="wb9sky") {chart1.series[0].addPoint([eval(i),eval(line_elements[4])],false,false);}
	    

	// now redraw sidebar graphs
	if (markerLayer.id=="wb9sky") { chart1.redraw();chart2.redraw();}
	
*/


// this function does all of the work in plotting the tracks
function plot_track(markerLayer) {
    
    N_old=markerLayer.markers.length;
    
    // start by reading the track file on the server
    var txtFile = new XMLHttpRequest();
    txtFile.open("POST", "./"+markerLayer.id+"track.txt", true);
    // define a function that executes on server response to the HttpRequest
    txtFile.onreadystatechange = function() {
	// Make sure the document is ready to parse and the file is found.
	if ((txtFile.readyState === 4) && (txtFile.status === 200)) {  
	    // Seperate each line into an array
	    var lines = txtFile.responseText.split("\n"); 
	    // only continue if there is new data
	    if ((lines.length-1)>N_old) {
		var i=0;
		// do only the new lines
		for (i=N_old;(lines.length-1)>i;i++){
		    // split up the lines into lat, long, altitude, etc.
		    var line_elements = lines[i].split(",");		    

		    // add a marker onto the map
		    addMarker(markerLayer,line_elements);

		    // update sidebar graphs 
		    if (i>0)   {	
			var line_elements_old = lines[i-1].split(",");
			//			var D=4189*Math.sqrt((line_elements[0]-line_elements_old[0])*(line_elements[0]-line_elements_old[0])+0.5679*(line_elements[1]-line_elements_old[1])*(line_elements[1]-line_elements_old[1]));
			var D=line_elements[3];
		    }
		    
		    if (markerLayer.id=="wb9sky") {chart2.series[0].addPoint([eval(D),eval(line_elements[4])],false,false);}
		    if (markerLayer.id=="wb9sky") {chart1.series[0].addPoint([eval(i),eval(line_elements[4])],false,false);}
		    		    
		} //end main loop

		// now redraw sidebar graphs
		if (markerLayer.id=="wb9sky") { chart1.redraw();chart2.redraw();}
		
		// set the visibility of the points to reflect the "current point only" 
		// toggle 
		setCurrent();

		// update the onscreen current balloon location text
		document.getElementById('BalloonStats').innerHTML="Current Dynamics: "+line_elements[4]+" ft, "+line_elements[3]+" mph, "+line_elements[2]+"&deg; heading";
		
	    }
	}}
    txtFile.send(null);
}

function readWinds()
{
    // start by reading the track file on the server
    var txtFile = new XMLHttpRequest();
    txtFile.open("POST", "./windfile.txt", true);
    // define a function that executes on server response to the HttpRequest
    txtFile.onreadystatechange = function() {
	// Make sure the document is ready to parse and the file is found.
	if ((txtFile.readyState === 4) && (txtFile.status === 200)) {  
	    // Seperate each line into an array
	    var lines = txtFile.responseText.split("\n"); 
	    for (i=0;(lines.length-1)>i;i++){
		// split up the lines into altitude, speed and direction
		wind_elements[i] = lines[i].split(",");		    
	    }
	}
    }
}


function setCurrent()
{
    var onlyCurrent = document.getElementById("toggle-id").checked;

    for (i=0;i<kc9lig_markerLayer.markers.length-1;i++) {
	kc9lig_markerLayer.markers[i].display(!onlyCurrent);}
    for (i=0;i<kc9lhw_markerLayer.markers.length-1;i++) {
	 kc9lhw_markerLayer.markers[i].display(!onlyCurrent);}
    for (i=0;i<wb9sky_markerLayer.markers.length-1;i++) {
	 wb9sky_markerLayer.markers[i].display(!onlyCurrent);}

    /*
    // doesn't work for some reason...
    kc9lig_markerLayer.markers[kc9lig_markerLayer.markers.length-1].display(true);
    kc9lhw_markerLayer.markers[kc9lhw_markerLayer.markers.length-1].display(true);
    wb9sky_markerLayer.markers[wb9sky_markerLayer.markers.length-1].display(true);
    */

}

function addMarker(markerLayer,lineE) {
    
    longit=lineE[1];
    latit=lineE[0];
    altitude=lineE[4];
    speed=lineE[3];
    direction=lineE[2];
  
    if (markerLayer.id=="kc9lig") var icon=iconred.clone();
    if (markerLayer.id=="kc9lhw") var icon=icongreen.clone();
    if (markerLayer.id=="wb9sky") var icon=iconblue.clone();
    
    var ll=(new OpenLayers.LonLat(longit,latit)).transform(proj, map.getProjectionObject());
    var popupContentHTML="<div style=\"background-color:white;\">"+"Altitude: "+altitude+" ft<br>Speed: "+speed+" mph<br> Direction: "+direction+"</div>";


    var feature = new OpenLayers.Feature(markerLayer, ll); 
    feature.closeBox = true;
    feature.popupClass = AutoSizeFramedCloud;
    feature.data.popupContentHTML = popupContentHTML;
    feature.data.overflow = "auto";
    feature.data.icon = icon;        
    feature.data.display = false;        
    
    var marker = feature.createMarker();
    
    var markerClick = function (evt) {
	if (this.popup == null) {
	    this.popup = this.createPopup(this.closeBox);
	    map.addPopup(this.popup);
	    this.popup.show();
	} else {
	    this.popup.toggle();
	}
	currentPopup = this.popup;
	OpenLayers.Event.stop(evt);
    };
    
    marker.events.register("mousedown", feature, markerClick);
    
    markerLayer.addMarker(marker);
}
