document.observe('dom:loaded', function() {
		initialize();
});

function initialize() {
	var latlng = new google.maps.LatLng(47.394631, 8.53363
		//<%= @artefact.get_current_location[:lat] %>, <%= @artefact.get_current_location[:long] %>
		);
	var mapOptions = {
	     zoom: 8,
	     center: latlng,
	     mapTypeId: google.maps.MapTypeId.HYBRID
	};

	var map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);

	var marker = new google.maps.Marker({
	  position: latlng,
	  map: map,
	  icon: image,
	});

	marker.setMap(map);
}