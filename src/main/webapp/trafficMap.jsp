<script>

console.log(${hotspots})
var map;
function initMap() {
	map = new google.maps.Map(document.getElementById('map'), {
	  zoom: 12,
	  center: new google.maps.LatLng(39.319,-76.607),
	  mapTypeId: 'terrain'
	});

	drawPoints(${hotspots});
	drawAreas(${hotspots});
	// displayPoints(${hotspots});

	// loadJSON(function(jsn) { 

	// });
}

$(document).ready(function() {
	displayFilters();
});

function loadJSON(callback) {
	var xobj = new XMLHttpRequest();
 	xobj.overrideMimeType("application/json");
 	xobj.open('GET', 'parking-citation.json', true); 
 	xobj.onreadystatechange = function () {
	 	if (xobj.readyState == 4 && xobj.status == "200") {
	 		callback(JSON.parse(xobj.responseText));
	 	}
 	};
 	xobj.send(null); 
 	console.log(xobj);
 }

function drawPoints(hotspots) {
	for (var i = 0; i < hotspots.length; i++) {
		var hotspot = hotspots[i];
		for (var j = 0; j < hotspots.incidents.length; j++) {
			var incidents = hotspot.incidents[0];
			// console.log(jsn.results[i].geometry.coordinates);
			var coords = incidents.coordinate;
			var latLng = new google.maps.LatLng(coords.x,coords.y);
			var marker = new google.maps.Marker({
				position: latLng,
				map: map,
				obj: hotspot.incidents[j]
			});

			marker.addListener('click', function() {
				displayPoints([this.obj]);
			});
		}
	}
}

function drawAreas(hotspots) {
	for (var i = 0; i < hotspots.length; i++) {
		var loc = hotspots[i].location
		var latLng = new google.maps.LatLng(loc.x, loc.y);
		var marker = new google.maps.Marker({
			position: latLng,
			map: map,
			icon, getCircle(1),
			incidents: hotspots[i].incidents,
			numIncidents: hotspots[i].numofIncidents
		});

		marker.addListener('click', function() {
			displayPoints(this.incidents);
		});
	}
}

// k. change implementation to accept area object instead
function displayPoints(points) {
	$('#points').html(); // k. clears the html in #points
	for (var i = 0; i < points.results.length; i++) {
		$('#points').append('<span>' + 
			'<p>' + points[i].coordinate.x+', '+points[i].coordinate.y+'</p>' +
			'<p>' + points[i].data.address + '</p>' +
			'<p>' + points[i].data.notes + '</p>' +
			'<p>' + points[i].data.issuedAt + '</p>' +
			'</span>');
	}
}

// HELPER FUNCTIONS

function getCircle(magnitude) {
	return {
		path: google.maps.SymbolPath.CIRCLE,
		fillColor: 'red',
		fillOpacity: .2,
		scale: Math.pow(2, magnitude) / 2,
		strokeColor: 'white',
		strokeWeight: .5
	}
}

function displayFilters () {
	for (var i = 0; i < uniqueNotes.length; i++) {
		$('#notes_select').append('<option value=' + uniqueNotes[i].split(" ").join("_") + '>' + uniqueNotes[i] + '</option>');
	}
}

function filterPointsByNotes(item) {
	$.post("/main", {
		value_notes: $('#notes_select').val(),
		value_date: $('#date_select').val()
	}, function() {
		alert($(item.target).val());
	});
}

function filterPointsByDate (item) {
	$.post("/main", {
		value_notes: $('#notes_select').val(),
		value_date: $('#date_select').val()
	}, function() {
		alert($(item.target).val());
	});
}

// HARDCODED VARIABLES

var uniqueNotes = ['All Violations', 'Red Light Violation', 'Right on Red',
                     'All Other Parking Meter Violations', 'Expired Tags',
                     'Mobile Speed Camera', 'Fixed Speed Camera',
                     'Residential Parking Permit Only',
                     'No Stopping/Standing Not Tow-Away Zone',
                     'No Stop/Park Street Cleaning',
                     'Obstruct/Impeding Movement of Pedestrian',
                     'All Other Stopping or Parking Violations',
                     'Less Than 15 feet from Fire Hydrant',
                     'No Stopping/Standing Tow Away Zone',
                     'No Parking/Standing In Transit Stop', 'Passenger Loading Zone',
                     'No Stopping//Parking Stadium Event Camden',
                     'Obstruct/Impeding Flow of Traffic', 'No Stop/Park Handicap',
                     'Exceeding 48 Hours', 'Commercial Veh/Residence under 20,000 lbs',
                     'Abandonded Vehicle', 'Fire Lane/Handicapped Violation',
                     'No Parking/Standing In Bus Stop/Bus Lane',
                     'No Parking/Standing In Bike Lanes',
                     'Commercial Veh/Residence over 20,000 lbs',
                     'Old Fixed Speed Camera',
                     'Obstructing/Imped Traffic Xwalk/inter/school',
                     'Blocking Garage or Driveway',
                     'Commercial Vehicle Obstruct/Imped Traffic Flow',
                     'Less 30\x92 from Intersection', 'In Taxicab Stand',
                     'No Stop/Stand/Park Cruising',
                     'No Parking/Stand Motor Home/Campr/Travel Trailer',
                     'No Stopping or No Parking Pimlico Event',
                     'No Parking/Standing Vendor Truck',
                     'Unlawful Dumping/Waste Hauler w/o Permit',
                     'Snow Emergency Route Violation', 'Res. Park Permit 4th Offense',
                     'No Stopping/Parking Stadium Event \x96 33rd']   
                     
 </script>