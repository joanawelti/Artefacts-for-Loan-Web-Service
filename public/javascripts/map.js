function initialize(lat, lon) {
	var latlng = new google.maps.LatLng(lat, lon);

	var mapOptions = {
	     zoom: 8,
	     center: latlng,
	     mapTypeId: google.maps.MapTypeId.HYBRID
	};

	var map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);

	var marker = new google.maps.Marker({
	  position: latlng,
	});

	marker.setMap(map);
}