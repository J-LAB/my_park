window.addEventListener('load', function() {

    var proj = new OpenLayers.Projection("EPSG:4326");

    var map = new OpenLayers.Map('map', {
        projection: 'EPSG:3857',
        layers: [
            new OpenLayers.Layer.OSM("OSM"
            )
        ],
        center: new OpenLayers.LonLat(-75.1667, 39.95)
            .transform(proj, 'EPSG:3857'),
        zoom: 13 
    });

    var parkStyle = {
        fill: true,
        fillColor: "#00FF00",
        fillOpacity: 0.3,
        strokeColor: "#008800",
        strokeOpacity: 0.7,
        strokeDashstyle: "dot" 

    }

    var trailStyle = {
        strokeColor: "#FF7F00",
            strokeWidth: 4
    }

    var trailsLayer = new OpenLayers.Layer.Vector("Trails Layer", { style: trailStyle });
    var parksLayer = new OpenLayers.Layer.Vector("Parks Layer", { style: parkStyle });
    var markers = new OpenLayers.Layer.Markers("Markers");
    map.addLayer(parksLayer);
    map.addLayer(trailsLayer);
    map.addLayer(markers);


    var size = new OpenLayers.Size(80,80);
    var offset = new OpenLayers.Pixel(-(size.w/2), -size.h);
    var icon = new OpenLayers.Icon('http://i.imgur.com/9Bw1rLa.png', size, offset);
    markers.addMarker(new OpenLayers.Marker(new OpenLayers.LonLat(-75.1667,39.95).transform(proj, map.getProjectionObject()),icon));
    markers.addMarker(new OpenLayers.Marker(new OpenLayers.LonLat(-75.1667, 39.95).transform(proj, map.getProjectionObject()),icon.clone()));

    function handler(request) {

        var geojson_format = new OpenLayers.Format.GeoJSON({
            'internalProjection': map.baseLayer.projection,
            'externalProjection': new OpenLayers.Projection("EPSG:4326")
        });

        this.layer.addFeatures(geojson_format.read(request.responseText));
    }

    var GeoJSONs = [
        {
            url: "assets/PPR_Boundaries.geojson",
            layer: parksLayer
        },
        {
            url:"assets/trails.geojson",
            layer: trailsLayer
        }
    ];        

    for (var i = 0; i < GeoJSONs.length; i++) {
        OpenLayers.Request.GET({
            url: GeoJSONs[i].url,
            callback: handler,
            scope: {
                layer: GeoJSONs[i].layer
            }
        });
    }

    var clicked = false;
    var startMarker = new OpenLayers.Marker(new OpenLayers.LonLat(0, 0));
    startMarker.display(false);
    var endMarker = new OpenLayers.Marker(new OpenLayers.LonLat(0, 0));
    endMarker.display(false);


    OpenLayers.Control.Click = OpenLayers.Class(OpenLayers.Control, {                
        defaultHandlerOptions: {
            'single': true,
            'double': false,
            'pixelTolerance': 0,
            'stopSingle': false,
            'stopDouble': false
        },

        initialize: function(options) {
            this.handlerOptions = OpenLayers.Util.extend(
                {}, this.defaultHandlerOptions
            );
            OpenLayers.Control.prototype.initialize.apply(
                this, arguments
            ); 
            this.handler = new OpenLayers.Handler.Click(
                this, {
                    'click': this.trigger
                }, this.handlerOptions
            );
        }, 

        trigger: function(e) {
            var lonlat = map.getLonLatFromPixel(e.xy).transform(map.getProjectionObject(), proj);
            if (clicked) {
                endMarker = new OpenLayers.Marker(map.getLonLatFromPixel(e.xy));
                var size = new OpenLayers.Size(21,25);
                var offset = new OpenLayers.Pixel(-(size.w/2), -size.h);
                var icon = new OpenLayers.Icon('http://www.openlayers.org/dev/img/marker.png', size, offset);
                markers.addMarker(endMarker);
                document.getElementById("startLat").value = startMarker.lonlat.transform(map.getProjectionObject(), proj).latitude;
                document.getElementById("startLon").value = startMarker.lonlat.transform(map.getProjectionObject(), proj).longitude;
                document.getElementById("endLat").value = endMarker.lonlat.transform(map.getProjectionObject(), proj).latitude;
                document.getElementById("endLon").value = endMarker.lonlat.transform(map.getProjectionObject(), proj).longitude;
                document.forms.ruler.submit();
            } else {
                startMarker.erase();
                endMarker.erase();
                startMarker = new OpenLayers.Marker(map.getLonLatFromPixel(e.xy));
                var size = new OpenLayers.Size(21,25);
                var offset = new OpenLayers.Pixel(-(size.w/2), -size.h);
                var icon = new OpenLayers.Icon('http://www.openlayers.org/dev/img/marker.png', size, offset);
                markers.addMarker(startMarker,icon);
            }
            clicked = !clicked;
        }

    });

    var click = new OpenLayers.Control.Click();
    map.addControl(click);
    click.activate();

    if ("geolocation" in navigator) {
        navigator.geolocation.getCurrentPosition(function(position) {
              map.setCenter(new OpenLayers.LonLat(position.coords.longitude, position.coords.latitude).transform(proj, map.getProjectionObject()));
        });
    }
}, false);

