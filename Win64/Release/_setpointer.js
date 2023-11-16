
        function setPointer(llat, llong) {
              alert("lat "+llat+" long "+llong);
            console.log(llat, llong);
            map.setView([llat, llong]);
            map.panTo([llat, llong]); //verificare
            marker.setLatLng([llat, llong]);
			alert("nuovo messaggio dopo setlatlng lat "+llat+" long "+llong);
			}