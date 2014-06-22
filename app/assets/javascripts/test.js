
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

    var map = new OpenLayers.Map('map', {
        projection: 'EPSG:3857',
        layers: [
            new OpenLayers.Layer.OSM( "Simple OSM Map")
        ],
        center: new OpenLayers.LonLat(-75.1667, 39.95)
            .transform('EPSG:4326', 'EPSG:3857'),
        zoom: 12 
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
    map.addLayer(parksLayer);
    map.addLayer(trailsLayer);

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


}, false);
