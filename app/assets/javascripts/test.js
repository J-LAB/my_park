
window.addEventListener('load', function() {
/*
    var parkStyle = new OpenLayers.StyleMap({
        "default": new OpenLayers.Style({
            fillColor: "#00FF00",
            fillOpacity: 0.1,
            strokeOpacity: 0.2,
            strokeColor: "#00FF00",
            graphicZIndex: 3,
            graphicOpacity: 0.5,
            transparent: true
        })
    });

    var trailStyle = new OpenLayers.StyleMap({
        "default": new OpenLayers.Style({
            strokeColor: "#000000",
            strokeOpacity: 1,
            graphicZIndex: 2,
            graphicOpacity:1 
        })
    });
    */


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


    if ("geolocation" in navigator) {
        navigator.geolocation.getCurrentPosition(function(position) {
              map.setCenter(new OpenLayers.LonLat(position.coords.longitude, position.coords.latitude).transform(proj, map.getProjectionObject()));
        });
    }


}, false);
