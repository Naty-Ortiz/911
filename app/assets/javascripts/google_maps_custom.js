

function gmap_show(project) {
    if ((project.latitude === null) || (project.longitude === null) ) {
        return 0;
    }

    handler = Gmaps.build('Google');
    handler.buildMap({ provider: {}, internal: {id: 'map'}}, function(){
        markers = handler.addMarkers([
            {
                "lat": project.latitude,
                "lng": project.longitude,
                "picture": {
                    //"url": 'http://www.planet-action.org/img/2009/interieur/icons/orange-dot.png',
                    "width":  32,
                    "height": 32
                }
            }
        ]);
        handler.bounds.extendWith(markers);
        handler.fitMapToBounds();
        handler.getMap().setZoom(17);
    });
}

function gmap_form(project) {
    handler = Gmaps.build('Google');
    handler.buildMap({ provider: {}, internal: {id: 'map'}}, function(){
        if (project && project.latitude && project.longitude) {
            markers = handler.addMarkers([
                {
                    "lat": project.latitude,
                    "lng": project.longitude,
                    "picture": {
                        "url": 'http://maps.google.com/mapfiles/ms/icons/green-dot.png',
                        "width":  32,
                        "height": 32
                    }
                }
            ]);
            handler.bounds.extendWith(markers);
            handler.fitMapToBounds();
            handler.getMap().setZoom(17);
        }
        else {
            handler.fitMapToBounds();
            handler.map.centerOn([-17.3941855, -66.1585695]);
            handler.getMap().setZoom(18);
        }
    });

    var markerOnMap;

    function placeMarker(location) {
        if (markerOnMap) {
            markerOnMap.setPosition(location);
        }
        else {
            markerOnMap = new google.maps.Marker({
                position: location,
                map: handler.getMap()
            });
        }
    }

    if(document.getElementById("map_lat").value !== ""){
        placeMarker(new google.maps.LatLng(document.getElementById("map_lat").value, document.getElementById("map_lng").value));
    }

    google.maps.event.addListener(handler.getMap(), 'click', function(event) {
        placeMarker(event.latLng);
        document.getElementById("map_lat").value = event.latLng.lat();
        document.getElementById("map_lng").value = event.latLng.lng();
    });


    var input = document.getElementById('pac-input');
 var searchBox = new google.maps.places.SearchBox(input);
 handler.getMap().controls[google.maps.ControlPosition.TOP_LEFT].push(input);

 // Bias the SearchBox results towards current map's viewport.

 var options = {

  componentRestrictions: {country: "bol"}
 };


 var autocomplete = new google.maps.places.Autocomplete(input, options);


handler.getMap().addListener('bounds_changed', function() {
   searchBox.setBounds(handler.getMap().getBounds());
 });
handler.getMap().setZoom(38);
 var markers = [];
 // Listen for the event fired when the user selects a prediction and retrieve
 // more details for that place.
 searchBox.addListener('places_changed', function() {
   var places = searchBox.getPlaces();

   if (places.length === 0) {
     return;
   }

   // Clear out the old markers.
   markers.forEach(function(marker) {
     marker.setMap(null);
   });
   markers = [];

   // For each place, get the icon, name and location.
   var bounds = new google.maps.LatLngBounds();
   places.forEach(function(place) {
     var icon = {
       url: place.icon,
       size: new google.maps.Size(71, 71),
       origin: new google.maps.Point(0, 0),
       anchor: new google.maps.Point(17, 34),
       scaledSize: new google.maps.Size(25, 25)
     };

     // Create a marker for each place.
     markers.push(new google.maps.Marker({
       map: map,
       icon: icon,
       title: place.name,
       position: place.geometry.location
     }));

     if (place.geometry.viewport) {
       // Only geocodes have viewport.
       bounds.union(place.geometry.viewport);
     } else {
       bounds.extend(place.geometry.location);
     }
   });
  handler.getMap().fitBounds(bounds);
 });
 handler.getMap().setZoom(18);

}
